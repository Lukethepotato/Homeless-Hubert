class_name Globals
extends Node

# This is a global script which contains critical miscellaneous information. It also contains (will contain) useful functions which should be universally accessible.

signal dropped_UI(attack_resource: player_attack, dropped_where_name: String)
signal clear_attack_selection()
signal turn_changed()
signal health_updated()
signal done

signal current_turn_reset()
#called whenever turns set back to 1

# Combo data
var all_player_combos: Array[player_combo]

# Game states
enum game_states {
	PAUSED,
	IN_BATTLE,
	DIALOGUE,
	ROAMING
}
var state = game_states.ROAMING;

var timer;
@export var current_turn := -1;
@export var enemy_goes_on_turn = 3

# ! CURRENT TURN LEGEND:
#-1 = not in fight 
#0 = fight intro
#1 = player choosing move 
#2 = first participant attack* 
#3 = second participant attack*
#*(could be player or fish depending on speed)

#if checking turn on the turn changed signal, use turn 4 instead

@export var enemy_node: Node2D
var ambivalent_turn := -1
# ! NOT FOR USE AS A WAY TO CHECK THE PREVIOUS TURN, HELP FOR CHECKING IF THE TURN HAS CHANGED
@export var combo_node: Node2D
enum location_types {
	NONE,
	LOW,
	HIGH,
	IGNORE
}

func _process(delta: float) -> void:
	if state == game_states.IN_BATTLE:
		if (current_turn != ambivalent_turn && current_turn > 1):
			turn_changed.emit();
			ambivalent_turn = current_turn
			# The following comments are for testing purposes.
			#clear_attack_selection.emit()
			#ambivalent_turn = current_turn
		if (current_turn > 3):
			print("current turn = 1 _ globalsAutoload")
			current_turn = 1
			current_turn_reset.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f11"):
		toggle_fullscreen();

# Checks what window mode the game is and toggles it accordingly
func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);

# This function initiates a battle, taking in a list of scenarios.
func start_battle(battle_scenarios) -> void:
	state = game_states.IN_BATTLE;
	PlayerAutoload.speed += PlayerAutoload.agility;
	current_turn = 0
	var rand_battleS_index = randf_range(0, battle_scenarios.size() -1)
	var instance = battle_scenarios[rand_battleS_index].instantiate()
	add_child(instance)
	
	current_turn = 1
	health_updated.emit();
	print("current turn = 1")

# Creates a timer with a duration equal to the duration parameter
func timeout(duration := 2.0) -> void:
	# To wait for the end of the timeout, please place the following line in your code:
	# await GlobalsAutoload.timer.timeout;
	
	timer = Timer.new();
	timer.wait_time = duration;
	timer.one_shot = true;
	get_tree().root.add_child(timer);
	timer.timeout.connect(timer.queue_free)
	timer.start();
