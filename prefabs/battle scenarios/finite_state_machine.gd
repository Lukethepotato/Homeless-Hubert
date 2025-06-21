extends Node2D

@export var initial_state: State
@export var active_state_change_triggers: Array[state_change_trigger]
@export var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_state_change_triggers():
	for i in active_state_change_triggers:
		if i.trigger_check:
			current_state = get_node(NodePath(i.state_change_to)) 
			
