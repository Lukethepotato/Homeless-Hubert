extends Node2D
@export var last_resort_attack: enemy_attack

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalsAutoload.current_turn == GlobalsAutoload.enemy_goes_on_turn:
		%BattleScen_AnimPlayer.play(_return_enemy_attack_choice().animation_name)
		print("enemy attack")
		
func _return_enemy_attack_choice() -> enemy_attack:
	for i in get_child_count():
		
		if get_child(i)._attack_verdict() != null:
			
			return get_child(i)._attack_verdict()
			#goes through each child in order and sees if it returns an attack
			#if it does it returns that attack
			
	return last_resort_attack
	
	
