extends Node2D

# This script manages the main menu node

func _ready() -> void:
	GlobalsAutoload.end_load.emit()

func _on_play_button_pressed() -> void:
	GlobalsAutoload.begin_load();
	await GlobalsAutoload.overlay_done
	get_tree().change_scene_to_file("res://prefabs/main_dock.tscn")

func _on_options_button_pressed() -> void:
	pass

func _on_credits_button_pressed() -> void:
	pass

func _on_exit_button_pressed() -> void:
	get_tree().quit()
