extends Node2D

# This script is attached to a node in the main scene called "all combo container" and does exactly what the name implies.

@export var combo_resources: Array[player_combo]
#wanna add combo? (:
#you need to first make the resource and define the attacks needed in the array in order
#then add that resource to this combo resource array
#this creates a sort of array in array thing
#it really an array of resources that each contain an array of the attacks

func _ready() -> void:
	BattleAutoload.combo_node = self;
	BattleAutoload.all_player_combos = combo_resources;
