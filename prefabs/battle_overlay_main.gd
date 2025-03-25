extends CanvasLayer

# This script is attached to the clickable UI of the battle scenario and handles checking both if the attack can be executed as well as clearing attack selection.

var tween;

func _ready() -> void:
	GlobalsAutoload.dropped_UI.connect(update_button)
	GlobalsAutoload.turn_changed.connect(speed_update);
	$attack_spots.position.y = -400;
	$info_displays.position.y = -400;
	$bottom_ui.position.y = 300;
	call_deferred("intro_tween");
	update_button();

# Function I made just bc i had to keep typing this over and over so to save time i made it a function
func reset_tween():
	if tween:
		tween.kill();

# Starts the battle. Plays the warning animation and tweens in the battle ui
func intro_tween():
	reset_tween()
	$battle_intro.visible = true;
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($battle_intro/ColorRect, "modulate:a", 1, 0.5).from(0)
	tween.tween_property($battle_intro/Warning, "modulate:a", 1, 0.5).from(0)
	$battle_intro/AnimatedSprite2D.play("Warning");
	GlobalsAutoload.timeout(1.666667);
	await GlobalsAutoload.timer.timeout;
	reset_tween();
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($battle_intro/ColorRect, "modulate:a", 0, 0.2)
	tween.tween_property($battle_intro/Warning, "modulate:a", 0, 0.2)
	await tween.finished;
	$info_displays.fetch_names();
	$battle_intro.visible = false;
	reset_tween();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($attack_spots, "position", Vector2(70,20), 0.5).from(Vector2(70,-400))
	tween.tween_property($info_displays, "position:y", 0, 0.5).from(-400)
	tween.tween_property($bottom_ui, "position:y", 0, 0.5).from(300)

# Handles the behavior of pressing the attack button
func _on_attack_button_pressed() -> void:
	if is_attack_ready() && GlobalsAutoload.current_turn == 1:
		BattleAutoload.update_turn_order();
		GlobalsAutoload.current_turn = 2
		print("current turn = 2 _ overlay")
		$"bottom_ui/attack button".disabled = true;
		reset_tween()
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"bottom_ui/attack button", "position:y", 450, 0.5).from(410)

# Handles the behavior of pressing the clear button
func _on_clear_chosen_attacks_pressed() -> void:
	if GlobalsAutoload.current_turn == 1:
		var tempSize:= PlayerAutoload.attack_resources_in.size()
		PlayerAutoload.attack_resources_in.clear()
		PlayerAutoload.attack_resources_in.resize(tempSize)
		
		for i in $attack_spots.get_child_count():
			$attack_spots.get_child(i).reset();
		
		call_deferred("update_button");

# Returns if all player attack slots are filled
func is_attack_ready() -> bool:
	for attack in PlayerAutoload.attack_resources_in:
		if attack != null:
			return true;
	return false;

# Updates the attack button, tweening it in and updating its text if necessary
func update_button(_fuckts1 = null, _fuckts2 = null):
	reset_tween();
	if is_attack_ready():
		# The following line is a Big 'Ol Band-Aid Fix (trademark pending)
		await GlobalsAutoload.done;
		call_deferred("update_button_speed_text")
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"bottom_ui/attack button", "position:y", 410, 0.5).from(700)
	else:
		tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
		tween.tween_property($"bottom_ui/attack button", "position:y", 700, 0.5)
	$"bottom_ui/attack button".disabled = not is_attack_ready();

# Un-disables the attack button after the turn resets
func speed_update():
	if GlobalsAutoload.current_turn == 4:
		update_button_speed_text();
		reset_tween()
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"bottom_ui/attack button", "position:y", 410, 0.5)
		$"bottom_ui/attack button".disabled = false;

# Updates the speed displayed under "Commence Attack" on the attack button
func update_button_speed_text():
	var player_text;
	var enemy_text;
	if BattleAutoload.get_player_speed() > BattleAutoload.get_enemy_speed():
		player_text = "[font_size=25][color=yellow][center]" + str(BattleAutoload.get_player_speed());
		enemy_text = "[font_size=25][color=dim_gray][center]" + str(BattleAutoload.get_enemy_speed());
		$"bottom_ui/attack button/verdict".text = "[font_size=25][color=yellow][center]Faster";
	elif BattleAutoload.get_player_speed() == BattleAutoload.get_enemy_speed():
		player_text = "[font_size=25][color=gray][center]" + str(BattleAutoload.get_player_speed());
		enemy_text = "[font_size=25][color=gray][center]" + str(BattleAutoload.get_enemy_speed());
		$"bottom_ui/attack button/verdict".text = "[font_size=25][color=gray][center]Tied";
	else:
		player_text = "[font_size=25][color=dim_gray][center]" + str(BattleAutoload.get_player_speed());
		enemy_text = "[font_size=25][color=yellow][center]" + str(BattleAutoload.get_enemy_speed());
		$"bottom_ui/attack button/verdict".text = "[font_size=25][color=red][center]Slower";
	$"bottom_ui/attack button/player_speed".text = player_text
	$"bottom_ui/attack button/enemy_speed".text = enemy_text
