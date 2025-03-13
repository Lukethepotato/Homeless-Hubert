class_name Player_Details
extends Node

# This is a global script which contains most of the details about the Player character. If needed, it will also contain functions that need to be universally accessible.

@export var health: int = 15
@export var attack_resources_in: Array[player_attack]
@export var goes_on_turn: int = 3
@export var attack_history: Array[player_attack]

func _ready() -> void:
	attack_resources_in.resize(2)
