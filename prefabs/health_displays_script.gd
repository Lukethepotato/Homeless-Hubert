extends Control

# This script updates the player health text every frame.

# Bad practice, should be refactored.

func _process(delta: float) -> void:
	$"Player health".text = str(PlayerAutoload.health)
	$"Enemy health".text = str(GlobalsAutoload.enemy_node.health)
