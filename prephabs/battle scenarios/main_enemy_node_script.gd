extends Node2D
@export var health: int = 20 
@export var current_block := GlobalsAutoload.location_types.NONE
@export var attack_history: Array[enemy_attack]

# This node/script will store information and functions relating to an enemy/enemies.

func _ready() -> void:
	GlobalsAutoload.enemy_node = self;
