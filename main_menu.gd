extends Node2D

# This script manages the overall main menu node; lower level scripts manage the specifics of the main menu (i.e. main_menu_options.gd).

var tween;
var button_pressed := false;

var scene_to_load = "res://prefabs/main_dock.tscn"
var save_dict_1;
var save_dict_2;
var save_dict_3;

signal save_file_pressed(file : int)

func _ready() -> void:
	save_file_pressed.connect(start_game)
	SaveAutoload.current_file = 0;
	save_dict_1 = SaveAutoload.load_data(1)
	save_dict_2 = SaveAutoload.load_data(2)
	save_dict_3 = SaveAutoload.load_data(3)
	
	if save_dict_1:
		$Save_Files/save_file_1/name.text = "[font_size=45.0]" + save_dict_1.get("player_name")
	else:
		$Save_Files/save_file_1/name.text = "[font_size=45.0]NEW GAME"
	if save_dict_2:
		$Save_Files/save_file_2/name.text = "[font_size=45.0]" + save_dict_2.get("player_name")
	else:
		$Save_Files/save_file_2/name.text = "[font_size=45.0]NEW GAME"
	if save_dict_3:
		$Save_Files/save_file_3/name.text = "[font_size=45.0]" + save_dict_3.get("player_name")
	else:
		$Save_Files/save_file_3/name.text = "[font_size=45.0]NEW GAME"
	
	GlobalsAutoload.end_load.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESCAPE") and $camera.offset != Vector2(0,0) and not button_pressed:
		button_pressed = true;
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK);
		tween.tween_property($camera, "offset", Vector2(0,0), 1.0);
		await tween.finished;
		button_pressed = false;

func start_game(file):
	SaveAutoload.current_file = file;
	var data;
	match file:
		1:
			data = save_dict_1
		2:
			data = save_dict_1
		3:
			data = save_dict_1
	if data:
		SaveAutoload.player_autload_reset()
	GlobalsAutoload.begin_load();
	await GlobalsAutoload.overlay_done
	GlobalsAutoload.state = GlobalsAutoload.game_states.ROAMING;
	get_tree().change_scene_to_file(scene_to_load)

func _on_play_button_pressed() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK);
	tween.tween_property($camera, "offset:x", 1152, 1.0);

func _on_options_button_pressed() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK);
	tween.tween_property($camera, "offset:y", -648, 1.0);

func _on_credits_button_pressed() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK);
	tween.tween_property($camera, "offset:y", 648, 1.0);

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_return_pressed() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK);
	tween.tween_property($camera, "offset:y", 0, 1.0);
