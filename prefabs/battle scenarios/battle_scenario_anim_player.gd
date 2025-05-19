extends AnimationPlayer

# This script contains a single function which increments the current_turn variable in the Globals autoload when the current animation of the battle scenario finishes.
	
func _process(delta: float) -> void:
	BattleAutoload._non_attack_animations(self, %Ailments_parent, "Enemy")
	# makes sure the enemy when there not attacking is doing their non attack animations
	
# Replace with function body.
