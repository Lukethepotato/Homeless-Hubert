extends CanvasLayer

# This script handles the logic behind the pause menu scene

var index := 0;
var max_index : int;
var selection : RichTextLabel;
var tween;
var is_ready := false;
var current_screen := 0;

func _ready() -> void:
	get_tree().paused = true;
	max_index = %text_nodes.get_child_count()-1;
	selection = %text_nodes.get_child(index);
	tween_in();

func _input(event: InputEvent) -> void:
	if is_ready and current_screen == 0:
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
	elif current_screen == 1 and event.is_action_pressed("ESCAPE"):
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK);
		tween.tween_property($menu_control, "position:y", 0, 1.0);
		current_screen = 0;

func update_text():
	var selected_text_prefix = "[center][color=yellow][font_size=40] "
	var unselected_text_prefix = "[center][font_size=40]"
	selection.text = unselected_text_prefix + selection.get_parsed_text().lstrip(" ")
	selection = %text_nodes.get_child(index);
	print(index)
	selection.text = selected_text_prefix + selection.get_parsed_text();

func process_selection():
	match index:
		0:
			tween_out();
		1:
			var new_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK);
			new_tween.tween_property($menu_control, "position:y", -648, 1.0);
			current_screen = 1;
		2:
			var success = SaveAutoload.save_data();
			var final_pos = 1042
			$saved.size.x = 100;
			$saved.text = "[center][font_size=30]saved!"
			if not success:
				$saved.size.x = 180;
				$saved.text = "[center][font_size=30]save failed :("
				final_pos = 962;
			var new_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART);
			new_tween.tween_property($saved, "position:x", final_pos, 0.5);
			await new_tween.finished;
			GlobalsAutoload.timeout(1.0, false);
			await GlobalsAutoload.timer.timeout;
			new_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART);
			new_tween.tween_property($saved, "position:x", 1152, 0.5);
		3:
			GlobalsAutoload.begin_load();
			await GlobalsAutoload.overlay_done
			get_tree().paused = false;
			get_tree().change_scene_to_file("res://main_menu.tscn")
			GlobalsAutoload.state = GlobalsAutoload.game_states.ROAMING
			queue_free()

func tween_in():
	if tween:
		tween.kill();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($background, "modulate:a", 1, 0.5).from(0);
	tween.tween_property(%paused, "position:y", 130, 0.5).from(-200);
	tween.tween_property(%paused, "modulate:a", 1, 0.5).from(0);
	tween.tween_property(%text_nodes, "position:y", 304, 0.5).from(650);
	tween.tween_property(%text_nodes, "modulate:a", 1, 0.5).from(0);
	await tween.finished
	update_text()
	is_ready = true;

func tween_out():
	if tween:
		tween.kill();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($background, "modulate:a", 0, 0.5);
	tween.tween_property(%paused, "position:y", -200, 0.5);
	tween.tween_property(%paused, "modulate:a", 0, 0.5)
	tween.tween_property(%text_nodes, "position:y", 650, 0.5)
	tween.tween_property(%text_nodes, "modulate:a", 0, 0.5)
	await tween.finished
	GlobalsAutoload.state = GlobalsAutoload.game_states.ROAMING
	get_tree().paused = false;
	queue_free()
