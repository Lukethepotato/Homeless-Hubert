extends CanvasLayer

# This script is attached to the clickable UI of the battle scenario and handles checking both if the attack can be executed as well as clearing attack selection.
var tween;

func _ready() -> void:
	GlobalsAutoload.dropped_UI.connect(update_button)
	$attack_spots.position.y = -400;
	$info_displays.position.y = -400;
	$bottom_ui.position.y = 300;
	call_deferred("intro_tween");
	update_button();

func intro_tween():
	if tween:
		tween.kill();
	$battle_intro.visible = true;
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($battle_intro/ColorRect, "modulate:a", 1, 0.5).from(0)
	tween.tween_property($battle_intro/Warning, "modulate:a", 1, 0.5).from(0)
	$battle_intro/AnimatedSprite2D.play("Warning");
	GlobalsAutoload.timeout(1.666667);
	await GlobalsAutoload.timer.timeout;
	tween.kill();
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($battle_intro/ColorRect, "modulate:a", 0, 0.2)
	tween.tween_property($battle_intro/Warning, "modulate:a", 0, 0.2)
	await tween.finished;
	$battle_intro.visible = false;
	tween.kill();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($attack_spots, "position:y", 0, 0.5).from(-400)
	tween.tween_property($info_displays, "position:y", 0, 0.5).from(-400)
	tween.tween_property($bottom_ui, "position:y", 0, 0.5).from(300)

func _on_attack_button_pressed() -> void:
	if is_attack_ready() && GlobalsAutoload.current_turn == 1:
		BattleAutoload.update_turn_order();
		GlobalsAutoload.current_turn = 2
		print("current turn = 2 _ overlay")

func _on_clear_chosen_attacks_pressed() -> void:
	var tempSize:= PlayerAutoload.attack_resources_in.size()
	PlayerAutoload.attack_resources_in.clear()
	PlayerAutoload.attack_resources_in.resize(tempSize)
	
	for i in $attack_spots.get_child_count():
		$attack_spots.get_child(i).reset();
	
	call_deferred("update_button");

func is_attack_ready() -> bool:
	for attack in PlayerAutoload.attack_resources_in:
		if attack != null:
			return true;
	return false;

func update_button(_fuckts1 = null, _fuckts2 = null):
	print("update button")
	if tween:
		tween.kill();
	if is_attack_ready():
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"bottom_ui/attack button", "position:y", 440, 0.5).from(700)
	else:
		tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
		tween.tween_property($"bottom_ui/attack button", "position:y", 700, 0.5)
	$"bottom_ui/attack button".disabled = not is_attack_ready();
