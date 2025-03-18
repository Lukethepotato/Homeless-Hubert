extends Node2D

# This script is attached to the parent node of the main scene. It contains the battle scenarios whilst also handling battle commencement.

@export var battle_scenarios : Array[PackedScene]

func _on_fishing_spot_body_entered(body: Node2D) -> void:
	if body.name == "Hubert":
		GlobalsAutoload.start_battle(battle_scenarios);
