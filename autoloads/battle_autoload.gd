extends Node

# This script contains miscellaneous data and functions pertaining to battles and battle calculations


signal attack_ready;
signal damage_dealt(damage : int, target, crit : bool, evade : bool);

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

#func initiate_combat():
	

# Changes the PlayerAutoload goes_on_turn and the GlobalsAutoload enemy_goes_on_turn according to agility values and attack priority
func update_turn_order():
	PlayerAutoload.speed = get_player_speed();
	GlobalsAutoload.enemy_node.speed = get_enemy_speed();
	print("Player speed = " + str(PlayerAutoload.speed));
	print("Enemy speed = " + str(GlobalsAutoload.enemy_node.speed));
	if PlayerAutoload.speed > GlobalsAutoload.enemy_node.speed or (PlayerAutoload.speed == GlobalsAutoload.enemy_node.speed and randi_range(1,2) == 1):
		PlayerAutoload.goes_on_turn = 2;
		GlobalsAutoload.enemy_goes_on_turn = 3;
	else:
		PlayerAutoload.goes_on_turn = 3;
		GlobalsAutoload.enemy_goes_on_turn = 2;

# Returns what the player's speed would be for this turn
func get_player_speed() -> int:
	var speed = PlayerAutoload.speed;
	for attack in PlayerAutoload.attack_resources_in:
		if attack != null:
			speed += attack.priority;
	if speed < 0:
		speed = 0;
	return speed;

# Returns what the enemy's speed would be for this turn
func get_enemy_speed() -> int:
	var speed = GlobalsAutoload.enemy_node.speed;
	for attack in GlobalsAutoload.enemy_node.attack_resources_in:
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
		perpetrator = GlobalsAutoload.enemy_node;
	if (target.to_lower() == "player"):
		victim = PlayerAutoload;
	else:
		victim = GlobalsAutoload.enemy_node;
	
	return [perpetrator, victim]
	
	
func _non_attack_animations(anim_player_node: AnimationPlayer, ailments_parent: Node2D):
	#plays all the non attack related animations on the enemy and player
	
	#its called from each of their respective animation players
	
	var overridables: Array[String] = ["idle","staggered"] #this contains all the animations names that are ok to overide]
	#for example:
	#"idle" is there because animations like the damaged one would probally happen while there in the idle animation
	#and therefore it would need to be overided to play
	var unoverridables: Array[String] = ["hubert_low_block","hubert_high_block"] #these animations wont end as long another attack isnt played
	var last_attack_name: String = ""
	
	if PlayerAutoload.attack_history.is_empty() == false:
		last_attack_name = PlayerAutoload.attack_history[PlayerAutoload.attack_history.size() -1].animation_name
	
	if GlobalsAutoload.current_turn != PlayerAutoload.goes_on_turn:
		if anim_player_node.is_playing() == false && unoverridables.has(last_attack_name) == false || overridables.has(anim_player_node.current_animation):
			if ailments_parent._animtion_decision() != "":
				anim_player_node.play(ailments_parent._animtion_decision())
			
			# there would also be the little attacked animations here
			else:
				anim_player_node.play("idle")
			
	
#instantiates new attack spots as child of parent chosen and resizes the attack resource size to the attacks per turn value
func setting_attack_spots(attack_spot_node: PackedScene, parent: Control, user: String):
	var user_data = BattleAutoload.convert_strs_to_attack_roles(user, user)[0]
	user_data.attack_resources_in.resize(user_data.attacks_per_turn)
	
	for i in user_data.attacks_per_turn:
		var new_attack_spot = attack_spot_node.instantiate()
		parent.add_child(new_attack_spot)
		

	


# Calculates the damage that should be dealt. Extraneous parameters to be placed after the first three
func calculate_damage(base_dmg : int, user, target, can_crit := true, guaranteed_hit := false) -> int:
	var damage := base_dmg;
	var crit = false;
	var evade = false;
	print("Base damage: " + str(damage))
	damage += user.strength;
	print("Strength damage: " + str(damage))
	damage -= target.defense;
	print("Defense damage: " + str(damage))
	if randi_range(1+user.luck, 100) >= 100 and can_crit:
		damage *= 2.5;
		print_rich("[color=gold][wave amp=50.0 freq=5.0][font_size=20]Critical: " + str(damage));
		crit = true;
	if target.evasion > 0 and randi_range(target.evasion, 100) >= 100 and not guaranteed_hit:
		damage = 0;
		print_rich("[color=red][shake amp=50.0 freq=5.0][font_size=20]Evaded: " + str(damage));
		evade = true;
	BattleAutoload.damage_dealt.emit(damage, target, crit, evade);
	return damage;

# This function does the combo effects
func apply_combo_effects(combo : player_combo) -> void:
	print("Applying combo effects")
	var enemy = GlobalsAutoload.enemy_node
	PlayerAutoload.attack_history.clear()
	match combo.animation_name:
		"combo_slippy_trip":
			print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]Slippy Trip");
			enemy.traits.erase(traits.SLIPPERY);
			enemy.health -= 10;
			enemy.poise -= 10; # TEMPORARY
			BattleAutoload.damage_dealt.emit(10, enemy, false, false);
			enemy.evasion -= 20;
			enemy.speed -= 2;
			if enemy.evasion < 0:
				enemy.evasion = 0;
			
			enemy.find_child("Ailments_parent")._instantiate_ailment(combo.ailment_give)
			
			GlobalsAutoload.shake_camera.emit(20)
	GlobalsAutoload.health_updated.emit();
				
	
func apply_attack_effects(attack_name: String, user: String, target: String) -> void:
	# somthing to note
	
	#since this is called from the damage donator both the player and the enemy call this (because of the roles)
	
	#so i use a string since i can just input the attacks animation name no matter if its a enemy or player attack
	var roles = BattleAutoload.convert_strs_to_attack_roles(user, target)
	
	var last_attack = roles[0].attack_history[roles[0].attack_history.size() -1]
	
	roles[1].speed -= last_attack.victim_speed_subtract;
	roles[1].defense -= last_attack.victim_defense_subtract
	# You should use the switch statement for unique effects like ailments rather than just a variable every attack has
	match attack_name:
		"hubert_basic_low":
			pass
		"hubert_basic_shove","hubert_basic_sweep":
			pass
		"enemy_attack":
			pass
			#roles[1].ailment_component_node._instantiate_ailment(last_attack.ailment_give)
			#Example of how enemys attack work
