extends Node2D

# This script is attached to the parent node of the main scene. It contains the battle scenarios whilst also handling battle commencement.

@export var battle_scenarios : Array[PackedScene]

func _on_fishing_spot_body_entered(body: Node2D) -> void:
	GlobalsAutoload.current_turn = 0
	var rand_battleS_index = randf_range(0, battle_scenarios.size() -1)
	var instance = battle_scenarios[rand_battleS_index].instantiate()
	add_child(instance)
	
	#later on the intro cinematic coding would go here
	
	GlobalsAutoload.current_turn = 1
	print("current turn = 1")
