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
		
		%BattleScen_AnimPlayer.play(get_parent().upcoming_attack.animation_name)
		$"..".attack_history.append(get_parent().upcoming_attack)
		print("enemy attack")
		
func _update_upcoming_attack():
	#if player choosing attacks turn decide the attack for next turn
		get_parent().upcoming_attack = _return_enemy_attack_choice()

# Returns which enemy_attack the enemy will use this turn
func _return_enemy_attack_choice() -> enemy_attack:
	for i in get_child_count():
		if get_child(i)._attack_verdict() != null:
			return get_child(i)._attack_verdict()
			#goes through each child in order and sees if it returns an attack
			#if it does it returns that attack
	return fallback_attack;
