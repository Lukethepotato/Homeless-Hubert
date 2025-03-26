extends Panel

# Handles the logic of the combo list opening/closing

var tween;
var mouse_hovering := false;
var is_open := false;



func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Left Click"):
		print("Fuck Yeah")
		if not is_open:
			if tween:
				tween.kill();
			tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true);
			tween.tween_property($bars, "rotation_degrees", 90, 0.5);
			tween.tween_property($combo_container, "size", Vector2(1142, 175), 0.5);
			$"combo_container/Combo list".visible = true;
			$"combo_container/Combo list".modulate.a = 0;
			tween.tween_property($"combo_container/Combo list", "position:x", 50, 0.5);
			tween.tween_property($"combo_container/Combo list", "modulate:a", 1, 0.5);
			is_open = true;
		else:
			if tween:
				tween.kill();
			tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true);
			tween.tween_property($bars, "rotation_degrees", 0, 0.5);
			tween.tween_property($combo_container, "size", Vector2(40, 40), 0.5);
			tween.tween_property($"combo_container/Combo list", "position:x", 0, 0.5);
			tween.tween_property($"combo_container/Combo list", "modulate:a", 0, 0.5);
			is_open = false;
			await tween.finished;
			$"combo_container/Combo list".visible = false;
