extends Node2D

@export var initial_state: State
@export var active_state_change_triggers: Array[state_change_trigger]
@export var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = initial_state
	BattleAutoload.current_turn_reset.connect(check_state_change_triggers)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_state_change_triggers():
	for i in active_state_change_triggers:
		if i.trigger_check:
			current_state.exit()
			#calls exit on old state
			
			current_state = get_node(NodePath(i.state_change_to)) 
			#sets new state
			
			current_state.enter()
			#calls enter on new state
			print_rich("[color=gold][wave amp=50.0 freq=5.0][font_size=20] state change to: " + current_state.name);
			break
			
