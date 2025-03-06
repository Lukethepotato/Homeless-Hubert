extends Node

signal dropped_UI(attack_resource: player_attack, dropped_where_name: String)
signal clear_attack_selection()
@export var current_turn: int = -1
@export var enemy_goes_on_turn = 4

#-1 = not in fight 
#0 = fight intro cinematic
#1 = player choosing move 
#2 first persons attack (could be player or fish depending on speed)
#3 sencond person attack (could be player or fish depending on speed)

#if you can make this an enum go ahead bucko

@export var enemy_node: NodePath
var previous_turn: int = -1
#Not really always the previous turn it just helps check if the turn has changed


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if (current_turn != previous_turn && current_turn > 1):
		pass
		#clear_attack_selection.emit()
		#previous_turn = current_turn
	if (current_turn > 3):
		current_turn = 1
