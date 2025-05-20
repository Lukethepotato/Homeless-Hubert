extends Node2D

# This script manages the main menu node

func _ready() -> void:
	set_menu()

func set_menu() -> void:
	$Panel.position = Vector2(627,17)
	$play_button.position = Vector2(651, 51)
	$options_button.position = Vector2(651, 197)
	$credits_button.position = Vector2(651, 341)
	$exit_button.position = Vector2(651, 484)

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
