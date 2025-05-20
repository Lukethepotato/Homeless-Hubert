extends CanvasLayer

# This script handles the logic behind the pause menu scene

var index := 0;
var max_index : int;
var selection : RichTextLabel;

func _ready() -> void:
	max_index = $text_nodes.get_child_count()-1;
	selection = $text_nodes.get_child(index);
	update_text()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UP"):
		if index > 0:
			index -= 1;
			print("index_changed")
		else:
			index = max_index
		update_text()
	if event.is_action_pressed("DOWN"):
		if index < max_index:
			index += 1
			print("index_changed")
		else:
			index = 0;
		update_text()
	if event.is_action_pressed('CONFIRM'):
		process_selection();

func update_text():
	var selected_text_prefix = "[center][color=yellow][font_size=40] "
	var unselected_text_prefix = "[center][font_size=40]"
	selection.text = unselected_text_prefix + selection.get_parsed_text().lstrip(" ")
	selection = $text_nodes.get_child(index);
	print(index)
	selection.text = selected_text_prefix + selection.get_parsed_text();

func process_selection():
	match index:
		0:
			tween_out();
		1:
			pass
		2:
			pass
		3:
			GlobalsAutoload.begin_load();
			await GlobalsAutoload.overlay_done
			get_tree().change_scene_to_file("res://main_menu.tscn")

func tween_in():
	pass

func tween_out():
	pass
