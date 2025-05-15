extends Node2D

# This script handles enemy attacking.

@export var fallback_attack: attack_parent
@export var attack_in_turn_index_finished: int = 0

func _ready() -> void:
	GlobalsAutoload.turn_changed.connect(start_enemy_attack)
	GlobalsAutoload.current_turn_reset.connect(_update_upcoming_attack)
	_update_upcoming_attack()
	
	
func _process(delta: float) -> void:
	pass
# Initiates the enemy's attack
func start_enemy_attack() -> void:
	if GlobalsAutoload.current_turn == GlobalsAutoload.enemy_goes_on_turn:
		
		GlobalsAutoload.timeout(.5)
		await GlobalsAutoload.timer.timeout
		
		while attack_in_turn_index_finished < get_parent().attack_resources_in.size():
		
			%AnimPlayer.play(get_parent().attack_resources_in[attack_in_turn_index_finished ].animation_name)
			update_block()
			$"..".attack_history.append(get_parent().attack_resources_in[attack_in_turn_index_finished])
			print("enemy attack")
			attack_in_turn_index_finished += 1
			await %AnimPlayer.animation_finished
			
		GlobalsAutoload.current_turn += 1
		attack_in_turn_index_finished = 0
		
		
	
func update_block():
	if get_parent().attack_resources_in[attack_in_turn_index_finished].gives_block != GlobalsAutoload.location_types.IGNORE:
		get_parent().current_block = get_parent().attack_resources_in[attack_in_turn_index_finished].gives_block
		#sets the block to upcoming attacks block unless its set to ignore
	
	
func _update_upcoming_attack():
	#if player choosing attacks turn decide the attack for next turn
	for i in get_parent().attack_resources_in.size():
		if %Ailments_parent._attack_decision() != "" && i == 0:
			get_parent().attack_resources_in[i] = %Ailments_parent._attack_decision()
		else:
			get_parent().attack_resources_in[i] = _return_enemy_attack_choice()

# Returns which attack_parent the enemy will use this turn
func _return_enemy_attack_choice() -> attack_parent:
	for i in get_child_count():
		var returned_attack :attack_parent = get_child(i)._attack_verdict()
		if returned_attack != null:
			print("attack verdict returned " + returned_attack.name)
			return returned_attack
			#goes through each child in order and sees if it returns an attack
			#if it does it returns that attack
	return fallback_attack;
