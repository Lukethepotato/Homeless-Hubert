extends AnimationPlayer

# This script contains a single function which increments the current_turn variable in the Globals autoload when the current animation of the battle scenario finishes.

# This is another script I think could potentially be incorporated into a single script attached to the parent node rather than a myriad of single use, otherwise obsolete scripts.

func _on_animation_finished(anim_name: StringName) -> void:
	if GlobalsAutoload.current_turn == GlobalsAutoload.enemy_goes_on_turn:
		GlobalsAutoload.current_turn += 1 # Replace with function body.
