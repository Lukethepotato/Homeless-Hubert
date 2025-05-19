extends Node2D
@export var ailment_component_prefab: PackedScene
@export var target: String # must be set to either "Player" or "Enemy" (if in enemy scene use "Enemy" and vise versa)
@export var target_data = null
@export var current_ailment_anim: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.current_turn_reset.connect(_turn_reset)
	target_data = BattleAutoload.convert_strs_to_attack_roles(target, target)
	target_data = target_data[0]
	
	target_data.ailment_component_node = self
		# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _turn_reset():
	if target == "Player": 
		_player_attack_forcing()
		#since the player and enemy chooses attacks diffrently the player attack force is updated here
	
func _player_attack_forcing():
	for i in PlayerAutoload.attack_resources_in.size():
		if _attack_decision().size()-1 >= i && _attack_decision().is_empty() == false:
			PlayerAutoload.manually_change_player_attack(_attack_decision()[i], false, i, false)

# returns the attack name for the most recents ailments force attack var (if there is none return "")
func _attack_decision() -> Array[attack_parent]:
	var all_forced_attacks: Array[attack_parent]
	
	for i in get_child_count():
			
		if get_child(i).current_ailment.force_attack != null && get_child(i).turns_left > 0:
			all_forced_attacks.append(get_child(i).current_ailment.force_attack)
			
		
	return all_forced_attacks
	#this is called in the enemy_attack_manager script and for the enemy and here for the player
			

#returns the animation name of the ailment with the highest animation priorty stat
func _animtion_decision() -> String:
	var current_ailment_winner: Node2D = null
	for i in get_child_count():
		
		var ailment_competitor: Node2D = get_child(i)
		if ailment_competitor != null:
			if ailment_competitor.current_ailment.animation_name != "":
				if current_ailment_winner == null || (ailment_competitor.current_ailment.animation_priority >= current_ailment_winner.current_ailment.animation_priority):
					current_ailment_winner = ailment_competitor
					
					
		
	if current_ailment_winner != null:
		return current_ailment_winner.current_ailment.animation_name
		
	else:
		return ""



	#if GlobalsAutoload.current_turn == target_data.goes_on_turn:
			#if (ailment_competitor.current_ailment.animation_priority >= current_ailment_anim.current_ailment.animation_priority) || current_ailment_anim == null:
				#%AnimPlayer.play(ailment_competitor.current_ailment.animation_name)
				#ailment_competitor = current_ailment_anim

func _can_change_block() -> bool:
	for i in get_child_count():
		if get_child(i).current_ailment.lock_block != GlobalsAutoload.location_types.IGNORE:
			return false
	return true
	
# returns the amount of the most recent ailment with a "attacks_per_turn_set" value higher than 0
func _attacks_per_turn_possible() -> int:
	var amount: int = 0
	for i in get_child_count():
			
		if get_child(i).current_ailment.attacks_per_turn_set > 0 && get_child(i).turns_left > 0:
			amount = get_child(i).current_ailment.attacks_per_turn_set 
		
	return amount
	#this is used in the battle autoload in the function "attack_resource_in_size_update()"
	

func _instantiate_ailment(ailment_chosen: ailment):
	var new_ailment = ailment_component_prefab.instantiate()
	add_child(new_ailment)
	new_ailment._begin_ailment(ailment_chosen)
	new_ailment.damage_donor_node = %damage_donator #i give it the node this way because the intianted nodes cant call it
	new_ailment.animation_player = %AnimPlayer
	
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]new ailment instainated");
	
	#this instiantes the ailment componets that way we can have multiple ailments at the same time
