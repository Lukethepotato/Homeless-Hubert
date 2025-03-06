extends Node
@export var health: int = 15
@export var attack_resources_in: Array[player_attack]
@export var goes_on_turn: int = 3

func _ready() -> void:
	attack_resources_in.resize(2) # Replace with function body.


func _process(delta: float) -> void:
	pass
