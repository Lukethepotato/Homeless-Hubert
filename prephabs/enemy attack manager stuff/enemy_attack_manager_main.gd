extends Node2D

# This script handles enemy attacking. 

@export var fallback_attack: enemy_attack

func _ready() -> void:
	GlobalsAutoload.turn_changed.connect(start_enemy_attack)

func start_enemy_attack() -> void:
	if GlobalsAutoload.current_turn == GlobalsAutoload.enemy_goes_on_turn:
		var chosen_attack = _return_enemy_attack_choice()
		
		await GlobalsAutoload.timer.timeout
		# need some help here jerm bear
		
		%BattleScen_AnimPlayer.play(chosen_attack.animation_name)
		$"..".attack_history.append(chosen_attack)
		print("enemy attack")
		
func _return_enemy_attack_choice() -> enemy_attack:
	for i in get_child_count():
		if get_child(i)._attack_verdict() != null:
			return get_child(i)._attack_verdict()
			#goes through each child in order and sees if it returns an attack
			#if it does it returns that attack
	return fallback_attack;
