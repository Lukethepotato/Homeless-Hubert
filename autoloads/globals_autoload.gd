extends Node

signal dropped_UI(attack_resource: player_attack, dropped_where_name: String)
@export var current_turn: int = -1
@export var enemy_node: NodePath
#-1 = not in fight 
#0 = fight intro cinematic
#1 = player choosing move 
#2 first persons attack (could be player or fish depending on speed)
#3 sencond person attack (could be player or fish depending on speed)

#if you can make this an enum go ahead bucko


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
