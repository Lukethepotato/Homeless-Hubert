extends Button

@export var file := 1;

enum states {
	NORMAL,
	DELETE_CONFIRMATION
}

var state = states.NORMAL;
var tween;

func _on_pressed() -> void:
	$"../..".save_file_pressed.emit(file);

func _on_delete_file_pressed() -> void:
	if state == states.NORMAL:
		state = states.DELETE_CONFIRMATION
		$delete_file.disabled = true;
		$confirmation.modulate.a = 0;
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true);
		tween.tween_property($delete_file, "modulate:a", 0, 0.2);
		tween.tween_property($file, "modulate:a", 0, 0.2);
		tween.tween_property($name, "modulate:a", 0, 0.2);
		tween.tween_property($playtime, "modulate:a", 0, 0.2);
		tween.tween_property($delete_bg, "size", Vector2(1052, 150), 1);
		tween.tween_property($delete_bg, "position", Vector2(0, 0), 1);
		await tween.finished;
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC);
		tween.tween_property($confirmation, "modulate:a", 1, 0.5);
		$confirmation.visible = true;

func _on_yes_pressed() -> void:
	if state == states.DELETE_CONFIRMATION:
		SaveAutoload.delete_data(file);
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC);
		tween.tween_property($confirmation, "modulate:a", 0, 0.2);
		tween.tween_property($delete_bg, "size", Vector2(0, 150), 1);
		await tween.finished;
		$delete_bg.modulate.a = 0;
		$delete_bg.size = Vector2(50,50);
		$delete_bg.position = Vector2(997, 95)
		$name.text = "[font_size=45.0]NEW GAME"
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true);
		tween.tween_property($delete_file, "modulate:a", 1, 0.5);
		tween.tween_property($file, "modulate:a", 1, 0.5);
		tween.tween_property($name, "modulate:a", 1, 0.5);
		tween.tween_property($playtime, "modulate:a", 1, 0.5);
		tween.tween_property($delete_bg, "modulate:a", 1, 0.5);
		await tween.finished
		$delete_file.disabled = false;
		state = states.NORMAL;

func _on_no_pressed() -> void:
	if state == states.DELETE_CONFIRMATION:
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true);
		tween.tween_property($confirmation, "modulate:a", 0, 0.2);
		tween.tween_property($delete_bg, "size", Vector2(50, 50), 1);
		tween.tween_property($delete_bg, "position", Vector2(997, 95), 1);
		await tween.finished;
		$confirmation.visible = false;
		$delete_file.disabled = false;
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true);
		tween.tween_property($delete_file, "modulate:a", 1, 0.2);
		tween.tween_property($file, "modulate:a", 1, 0.2);
		tween.tween_property($name, "modulate:a", 1, 0.2);
		tween.tween_property($playtime, "modulate:a", 1, 0.2);
		await tween.finished;
		state = states.NORMAL;
