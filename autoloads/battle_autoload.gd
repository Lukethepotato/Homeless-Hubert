extends Node

# This script contains miscellaneous data and functions pertaining to battles and battle calculations

signal battle_start()
signal battle_intro_finished()
signal battle_end()

signal turn_changed()
signal current_turn_reset()
signal player_turn_end()
signal enemy_turn_end()
signal health_updated()
signal attack_ready;
signal damage_dealt(damage : int, target, crit : bool, evade : bool);
signal done_updating_attacks()

# ! CURRENT TURN LEGEND:
#-1 = not in fight 
#0 = fight intro
#1 = player choosing move 
#2 = first participant attack* 
#3 = second participant attack*
#*(could be player or fish depending on speed)

enum battle_states {
	NOT_IN_BATTLE = -1,
	INTRO,
	SELECTION,
	ACTION_1,
	ACTION_2,
	AFTER_ACTIONS,
}

#if checking turn on the turn changed signal, use turn 4 instead
@export var current_turn_state := -1;
var current_turn = 1;
var extra_turns = 0;
var previous_extra_turns = 0;
#@export var 
var previous_turn_state = -1
var current_battle_scenario;
@export var enemy_node: Node2D
# ! NOT FOR USE AS A WAY TO CHECK THE PREVIOUS TURN, HELP FOR CHECKING IF THE TURN HAS CHANGED
@export var combo_node: Node2D
var all_player_combos: Array[player_combo]

enum traits {
	SLIPPERY,
	OBESE,
	FLEXIBLE,
	RIGID,
	VAMPIRE,
	FRENZIED,
	CALM,
	FERAL,
	DEADEYE,
	HARDY,
	INTELLIGENT
}
enum ailments {
	POISON,
	DAZE,
	STAGGERED
}
enum location_types {
	NONE,
	LOW,
	HIGH,
	IGNORE
}

func _process(delta: float) -> void:
	if GlobalsAutoload.state == GlobalsAutoload.game_states.IN_BATTLE:
		if (current_turn_state != previous_turn_state && current_turn_state > 1):
			turn_changed.emit();
			previous_turn_state = current_turn_state
			# The following comments are for testing purposes.
			#clear_attack_selection.emit()
			#previous_turn_state = current_turn
		if (current_turn_state == battle_states.AFTER_ACTIONS):
			print("current turn = 1 _ globalsAutoload")
			current_turn_state = battle_states.SELECTION
			current_turn += 1;
			current_turn_reset.emit()

# This function initiates a battle, taking in a list of scenarios.
func start_battle(battle_scenarios) -> void:
	GlobalsAutoload.state = GlobalsAutoload.game_states.IN_BATTLE;
	PlayerAutoload.stat_dictionary.speed += PlayerAutoload.stat_dictionary.agility;
	current_turn_state = battle_states.INTRO
	var rand_battleS_index = randf_range(0, battle_scenarios.size() -1)
	var instance = battle_scenarios[rand_battleS_index].instantiate()
	call_deferred("add_child", instance)
	current_battle_scenario = instance;
	battle_start.emit();
	
	current_turn_state = battle_states.SELECTION
	health_updated.emit();
	print("current turn = ")

# Changes the PlayerAutoload goes_on_turn and the GlobalsAutoload enemy_goes_on_turn according to agility values and attack priority
func update_turn_order():
	var player_speed = get_player_speed();
	var enemy_speed = get_enemy_speed();
	print("Player speed = " + str(player_speed));
	print("Enemy speed = " + str(enemy_speed));
	if player_speed > enemy_speed or (player_speed == enemy_speed and randi_range(1,2) == 1):
		if previous_extra_turns == 0:
			extra_turns = int(log(player_speed / enemy_speed)/log(2))
		
		PlayerAutoload.goes_during_state = battle_states.ACTION_1;
		enemy_node.goes_during_state = battle_states.ACTION_2;
	else:
		#if previous_extra_turns == 0:
			#extra_turns = int(log(enemy_speed / player_speed)/log(2))
		
		PlayerAutoload.goes_during_state = battle_states.ACTION_2;
		enemy_node.goes_during_state = battle_states.ACTION_1;
	previous_extra_turns = extra_turns;
	print_rich("[font_size=100][color=red]"+str(extra_turns));

# Returns what the player's speed would be for this turn
func get_player_speed() -> int:
	var speed = PlayerAutoload.stat_dictionary.speed;
	for attack in PlayerAutoload.attack_resources_in:
		if attack != null:
			speed += attack.priority;
	if speed < 0:
		speed = 0;
	return speed;

# Returns what the enemy's speed would be for this turn
func get_enemy_speed() -> int:
	var speed = enemy_node.stat_dictionary.speed;
	for attack in enemy_node.attack_resources_in:
		if attack != null:
			speed += attack.priority;
	#return attack choice doenst give the actual attack done just a possibilty
	#using upcoming_attack gets the actuall one
	if speed < 0:
		speed = 0;
	return speed;

# Returns a two-item array in the format of [User, Target]
func convert_strs_to_attack_roles(user : String, target : String) -> Array:
	var perpetrator;
	var victim;
	
	# This section figures out what exactly the User and Target strings denote
	if (user.to_lower() == "player"):
		perpetrator = PlayerAutoload;
	else:
		perpetrator = enemy_node;
	if (target.to_lower() == "player"):
		victim = PlayerAutoload;
	else:
		victim = enemy_node;
	
	return [perpetrator, victim]

# since the player and enemy both manage their attacks in diffrent nodes this helps get them
func convert_strs_to_attack_manager(user: String, target: String) -> Array:
	var user_attack_man;
	var target_attack_man;
	
	if (user.to_lower() == "player"):
		user_attack_man= PlayerAutoload.animation_player;
	else:
		user_attack_man = enemy_node.enemy_attack_manager_node;
	if (target.to_lower() == "player"):
		target_attack_man = PlayerAutoload.animation_player;
	else:
		target_attack_man = enemy_node.enemy_attack_manager_node;
	
	return [user_attack_man, target_attack_man]

func convert_to_elevation(input: location_types) -> location_types:
	#input a location and returns its elavation counterpart
	if input == location_types.LOW:
		return location_types.HIGH
		
	elif input == location_types.HIGH:
		return location_types.LOW
	
	else:
		return input
		#if you where to input "none" or "ignore" it would just return it back

# play an attack manually (for if you wanted like a reaction attack to play for example)
func _manual_play_attack(user: String, attack: attack_parent):
	var user_data = BattleAutoload.convert_strs_to_attack_roles(user, user)[0]
	var user_attack_man = BattleAutoload.convert_strs_to_attack_manager(user, user)[0]
	
	user_data.animation_player.play(attack.animation_name)
	user_attack_man.update_block()
	
#plays all the non attack related animations on the enemy and player
#called from the each users respective animation player
func _non_attack_animations(anim_player_node: AnimationPlayer, ailments_parent: Node2D, user: String):
	
	#its called from each of their respective animation players
	
	var user_data = BattleAutoload.convert_strs_to_attack_roles(user, user)[0]
	var overridables: Array[String] = ["idle","staggered"] #this contains all the animations names that are ok to overide]
	#for example:
	#"idle" is there because animations like the damaged one would probally happen while there in the idle animation
	#and therefore it would need to be overided to play
	var unoverridables: Array[String] = ["hubert_low_block","hubert_high_block"] #these animations wont end as long another attack isnt played
	var last_attack_name: String = ""
	
	if user_data.attack_history.is_empty() == false:
		last_attack_name = user_data.attack_history[user_data.attack_history.size() -1].animation_name
	
	if BattleAutoload.current_turn_state != user_data.goes_during_state:
		if anim_player_node.is_playing() == false && unoverridables.has(last_attack_name) == false || overridables.has(anim_player_node.current_animation):
			if ailments_parent._animtion_decision() != "":
				anim_player_node.play(ailments_parent._animtion_decision())
			
			# there would also be the little attacked animations here
			else:
				anim_player_node.play("idle")
			
	
#instantiates new attack spots as child of parent chosen and resizes the attack resource size to the attacks per turn value
#called from the player and enemy attack spots parent in the battle overlay on turn reset
func setting_attack_spots(attack_spot_node: PackedScene, parent: Control, user: String, orgin_pos: Vector2, pos_offset: Vector2):
	var user_data = BattleAutoload.convert_strs_to_attack_roles(user, user)[0]
	
	attack_resources_in_size_update(user) #updates size of resources in
	var attacks_per_turn: int = user_data.attack_resources_in.size()
	
	
	#this whole section just deletes all the users attack spots then adds the new amount
	if parent.get_child_count() != attacks_per_turn:
		if parent.get_child_count() > 0:
			for i in parent.get_child_count():
				parent.get_child(i).queue_free()
		
		for i in attacks_per_turn:
			var new_attack_spot = attack_spot_node.instantiate()
			parent.add_child(new_attack_spot)
			
			new_attack_spot.position = orgin_pos
			new_attack_spot.position += (pos_offset) * i
		
#this updates the size of the users attack_resources_in size to its intended amount
#all things that substantially change the size should be here
func attack_resources_in_size_update(user: String):
	var user_data = BattleAutoload.convert_strs_to_attack_roles(user, user)[0]
	var resize_to: int = user_data.attacks_per_turn
	
	if user_data.ailment_component_node != null && user_data.ailment_component_node._attacks_per_turn_possible() > 0:
		resize_to = user_data.ailment_component_node._attacks_per_turn_possible()
		
	user_data.attack_resources_in.resize(resize_to)
	
# Calculates the damage that should be dealt. Extraneous parameters to be placed after the first three
func calculate_damage(base_dmg : int, user, target, can_crit := true, guaranteed_hit := false) -> int:
	var damage := base_dmg;
	var crit = false;
	var evade = false;
	print("Base damage: " + str(damage))
	damage += user.stat_dictionary.strength;
	print("Strength damage: " + str(damage))
	damage -= target.stat_dictionary.defense;
	if damage < 0:
		damage = 0;
	print("Defense damage: " + str(damage))
	if randi_range(1+user.stat_dictionary.luck, 100) >= 100 and can_crit:
		damage *= 2.5;
		print_rich("[color=gold][wave amp=50.0 freq=5.0][font_size=20]Critical: " + str(damage));
		crit = true;
	if target.stat_dictionary.evasion > 0 and randi_range(target.stat_dictionary.evasion, 100) >= 100 and not guaranteed_hit:
		damage = 0;
		print_rich("[color=red][shake amp=50.0 freq=5.0][font_size=20]Evaded: " + str(damage));
		evade = true;
		user.attack_history.clear();
	BattleAutoload.damage_dealt.emit(damage, target, crit, evade);
	return damage;

# This function does the combo effects
func apply_combo_effects(combo : player_combo) -> void:
	print("Applying combo effects")
	var enemy = enemy_node
	PlayerAutoload.attack_history.clear()
	match combo.animation_name:
		"combo_slippy_trip":
			print_rich("[color=cornflower_blue][wave amp=50.0 freq=5.0][font_size=50]Slippy Trip");
			enemy.traits.erase(traits.SLIPPERY);
			enemy.stat_dictionary.health -= 10;
			enemy.stat_dictionary.poise -= 10; # TEMPORARY
			BattleAutoload.damage_dealt.emit(10, enemy, false, false);
			enemy.stat_dictionary.evasion -= 20;
			enemy.stat_dictionary.speed -= 2;
			if enemy.stat_dictionary.evasion < 0:
				enemy.stat_dictionary.evasion = 0;
			
			enemy.find_child("Ailments_parent")._instantiate_ailment(combo.ailment_give)
			
			GlobalsAutoload.shake_camera.emit(20)
		"combo_guard_break":
			BattleAutoload.damage_dealt.emit(10, enemy, false, false);
			print_rich("[color=slate_gray][shake amp=50.0 freq=5.0][font_size=50]Guard Break");
			enemy.find_child("Ailments_parent")._instantiate_ailment(combo.ailment_give)
		"combo_bolt_cola":
			BattleAutoload.damage_dealt.emit(10, enemy, false, false);
			print_rich("[color=chartreuse][shake rate=20.0 level=20][font_size=50]Bolt Cola");
			PlayerAutoload.ailment_component_node._instantiate_ailment(combo.ailment_give)
	health_updated.emit();

func apply_attack_effects(last_attack: attack_parent, user: String, target: String) -> void:
	# somthing to note
	
	#since this is called from the damage donator both the player and the enemy call this (because of the roles)
	
	#so i use a string since i can just input the attacks animation name no matter if its a enemy or player attack
	var roles = BattleAutoload.convert_strs_to_attack_roles(user, target)
	
	roles[1].stat_dictionary.speed -= last_attack.victim_speed_subtract;
	roles[1].stat_dictionary.defense -= last_attack.victim_defense_subtract
	# You should use the switch statement for unique effects like ailments rather than just a variable every attack has
	match last_attack.animation_name:
		"hubert_basic_low":
			roles[0].ailment_component_node._instantiate_ailment(load("res://Resources/ailments/staggered.tres"))
		"hubert_basic_shove","hubert_basic_sweep":
			pass
		"enemy_attack":
			pass
		
		
		#roles[1].ailment_component_node._instantiate_ailment(last_attack.ailment_give)
		#Example of how enemys attack work
