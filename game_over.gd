extends CanvasLayer

var tween;

func _ready() -> void:
	#await get_tree().process_frame
	get_tree().paused = true;
	$background.visible = true;
	$game_over.visible = false;
	$move_on.visible = false;
	$music.play()
	GlobalsAutoload.timeout(2.0, false);
	await GlobalsAutoload.timer.timeout;
	$game_over.modulate.a = 0;
	$game_over.visible = true;
	$move_on.modulate.a = 0;
	$move_on.visible = true;
	$move_on.disabled = true;
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD);
	tween.tween_property($game_over, "modulate:a", 1, 1);
	GlobalsAutoload.timeout(1.5, false);
	await GlobalsAutoload.timer.timeout;
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD);
	tween.tween_property($move_on, "modulate:a", 1, 0.5);
	await tween.finished;
	$move_on.disabled = false;


func _on_move_on_pressed() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD);
	tween.tween_property($music, "volume_db", -80, 3);
	GlobalsAutoload.begin_load();
	await GlobalsAutoload.overlay_done
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://main_menu.tscn")
	queue_free()
