extends Node

# This is a global script which contains critical miscellaneous information. It also contains (will contain) useful functions which should be universally accessible.

signal dropped_UI(attack_resource: attack_parent, dropped_where_name: String)
signal clear_attack_selection()
signal game_over()

#called whenever turns set back to 1
signal shake_camera(shake_amount: float)
#40 good default shake_amount
signal info_popup_open(clicked_on)

var camera : Camera2D;
var mortality := true;

# Game states
enum game_states {
	PAUSED,
	IN_BATTLE,
	DIALOGUE,
	ROAMING,
	GAME_OVER
}
var state = game_states.ROAMING;

var loading_overlay_path = load("res://loading_overlay.tscn");
var pause_menu_path = load("res://pause_menu.tscn");
var game_over_path = load("res://game_over.tscn");
signal overlay_done;
signal end_load

var timer;

# this is a lil note for lukey poo who forgets how to print Rich
# print_rich("[color=gold][wave amp=50.0 freq=5.0][font_size=20] PUT TEXT HERE ");

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f11"):
		toggle_fullscreen();

# Checks what window mode the game is and toggles it accordingly
func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);

func begin_load():
	if not get_tree().root.get_node_or_null("loading_overlay"):
		var loading_overlay = loading_overlay_path.instantiate();
		get_tree().get_root().add_child(loading_overlay);

func pause():
	var pause_menu = pause_menu_path.instantiate();
	get_tree().get_root().add_child(pause_menu);
	state = game_states.PAUSED;

func trigger_game_over():
	if mortality:
		if BattleAutoload.current_battle_scenario:
			BattleAutoload.current_battle_scenario.queue_free()
		game_over.emit()
		var game_over = game_over_path.instantiate();
		get_tree().get_root().add_child(game_over);
		state = game_states.GAME_OVER;

# Creates a timer with a duration equal to the duration parameter
func timeout(duration := 2.0, pausable := true) -> void:
	# To wait for the end of the timeout, please place the following line in your code:
	# await GlobalsAutoload.timer.timeout;
	
	timer = Timer.new();
	if not pausable:
		timer.process_mode = Node.PROCESS_MODE_ALWAYS;
	timer.wait_time = duration;
	timer.one_shot = true;
	get_tree().root.add_child(timer);
	timer.timeout.connect(timer.queue_free)
	timer.start();
