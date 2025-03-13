extends Node2D
@export var health: int = 20 

# This node/script will store information and functions relating to an enemy/enemies.

func _ready() -> void:
	GlobalsAutoload.enemy_node = self;
