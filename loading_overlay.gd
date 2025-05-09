extends CanvasLayer

# This script handles the loading screen logic (dropping onto the screen and sliding out)

func _ready() -> void:
	intro()

func intro():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE).set_parallel(true);
	tween.tween_property($background, "position:y", 0, 1.5).from(-800);
	tween.tween_property($loading_text, "position:y", 0, 1.5).from(-800);
	await tween.finished;
	GlobalsAutoload.overlay_done.emit();
	await GlobalsAutoload.end_load;
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART).set_parallel(true);
	tween.tween_property($background, "position:y", -800, 1.5).from(0);
	tween.tween_property($loading_text, "position:y", -800, 1.5).from(0);
	await tween.finished;
	GlobalsAutoload.overlay_done.emit();
	queue_free()
