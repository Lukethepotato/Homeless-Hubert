extends Node2D

# This script handles enemy attacking.

@export var fallback_attack: enemy_attack

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
		
		%AnimPlayer.play(get_parent().upcoming_attack.animation_name)
		update_block()
		$"..".attack_history.append(get_parent().upcoming_attack)
		print("enemy attack")
	
func update_block():
	if get_parent().upcoming_attack.gives_block != 3:
		get_parent().current_block = get_parent().upcoming_attack.gives_block
		#sets the block to upcoming attacks block unless its set to ignore
	
	
func _update_upcoming_attack():
	#if player choosing attacks turn decide the attack for next turn
		get_parent().upcoming_attack = _return_enemy_attack_choice()

# Returns which enemy_attack the enemy will use this turn
func _return_enemy_attack_choice() -> enemy_attack:
	for i in get_child_count():
		var returned_attack :enemy_attack = get_child(i)._attack_verdict()
		if returned_attack != null:
			print("attack verdict returned " + returned_attack.name)
			return returned_attack
			#goes through each child in order and sees if it returns an attack
			#if it does it returns that attack
	return fallback_attack;
