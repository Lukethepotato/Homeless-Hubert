extends AnimationPlayer

# This script contains a single function which increments the current_turn variable in the Globals autoload when the current animation of the battle scenario finishes.
	
func _process(delta: float) -> void:
	BattleAutoload._non_attack_animations(self, %Ailments_parent)
	

func _on_animation_finished(anim_name: StringName) -> void:
	if GlobalsAutoload.current_turn == GlobalsAutoload.enemy_goes_on_turn:
		GlobalsAutoload.current_turn += 1
		print("current turn + 1 _ enemy") # Replace with function body.
