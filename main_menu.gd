extends Node2D

# This script manages the overall main menu node; lower level scripts manage the specifics of the main menu (i.e. main_menu_options.gd).

var tween;

func _ready() -> void:
	GlobalsAutoload.end_load.emit()

func _on_play_button_pressed() -> void:
	GlobalsAutoload.begin_load();
	await GlobalsAutoload.overlay_done
	get_tree().change_scene_to_file("res://prefabs/main_dock.tscn")

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
