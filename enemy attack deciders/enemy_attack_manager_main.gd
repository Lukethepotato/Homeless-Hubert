extends Node2D

# This script handles enemy attacking.

@export var fallback_attack: attack_parent
@export var attack_in_turn_index_finished: int = 0

func _ready() -> void:
	BattleAutoload.turn_changed.connect(start_enemy_attack)
	BattleAutoload.current_turn_reset.connect(_update_upcoming_attack)
	_update_upcoming_attack()
	
	
func _process(delta: float) -> void:
	pass

# Initiates the enemy's attack
func start_enemy_attack() -> void:
	if BattleAutoload.current_turn_state == BattleAutoload.enemy_node.goes_during_state:
		BattleAutoload.enemy_node.stat_dictionary.speed = BattleAutoload.get_enemy_speed()
		
		GlobalsAutoload.timeout(.5)
		await GlobalsAutoload.timer.timeout
		
		while attack_in_turn_index_finished < get_parent().attack_resources_in.size():
		
			%AnimPlayer.play(get_parent().attack_resources_in[attack_in_turn_index_finished ].animation_name)
			update_block()
			$"..".attack_history.append(get_parent().attack_resources_in[attack_in_turn_index_finished])
			print("enemy attack")
			attack_in_turn_index_finished += 1
			await %AnimPlayer.animation_finished
			
		# this goes through every attack, plays it, waits till its over then does the next one
			
		if BattleAutoload.current_turn_state == BattleAutoload.battle_states.ACTION_1 && BattleAutoload.extra_turns > 0:
			BattleAutoload.current_turn_state = BattleAutoload.battle_states.SELECTION;
			BattleAutoload.extra_turns -= 1;
			BattleAutoload.current_turn_reset.emit()
		else:
			BattleAutoload.current_turn_state += 1
			attack_in_turn_index_finished = 0
		
		BattleAutoload.enemy_turn_end.emit()
		#then once all the attacks are done it adds a turn and resets the attack index back to 0 so it can all happen again
				
		
	
func update_block():
	if get_parent().attack_resources_in[attack_in_turn_index_finished].gives_block != BattleAutoload.location_types.IGNORE:
		get_parent().current_block = get_parent().attack_resources_in[attack_in_turn_index_finished].gives_block
		#sets the block to upcoming attacks block unless its set to ignore
	
#this decides the enemys upcoming attacks
#updates on turn reset
func _update_upcoming_attack():
	get_parent().attack_resources_in.resize(10) 
	# sets the attacks in size to a whole bunch then fills it all in with the upcoming attacks
	# even more than will be used
	
	for i in get_parent().attack_resources_in.size():
		if %Ailments_parent._attack_decision().size()-1 >= i && %Ailments_parent._attack_decision().is_empty() == false:
			get_parent().attack_resources_in[i] = %Ailments_parent._attack_decision()[i]
			#this checks if the current attack is supposed to be a forced attack from a current ailment
		else:
			get_parent().attack_resources_in[i] = _return_enemy_attack_choice()
			
	BattleAutoload.attack_resources_in_size_update("Enemy")
	#now that the for loop is over and its all full of way to many attacks
	#it trims it down to the actuall size

# Returns which attack_parent the enemy could use this turn
func _return_enemy_attack_choice() -> attack_parent:
	for i in get_child_count():
		if get_child(i).disabled == true:
			var returned_attack :attack_parent = get_child(i)._attack_verdict()
			if returned_attack != null:
				#print("attack verdict returned " + returned_attack.name)
				return returned_attack
			#goes through each child in order and sees if it returns an attack
			#if it does it returns that attack
	return fallback_attack;
