extends Control

# This script updates the player health text every frame.

func _ready() -> void:
	GlobalsAutoload.health_updated.connect(update_health)

func update_health() -> void:
	$"Player health".text = str(PlayerAutoload.health)
	$"Enemy health".text = str(GlobalsAutoload.enemy_node.health)
