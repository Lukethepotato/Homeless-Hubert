extends CanvasLayer

# This script is attached to the clickable UI of the battle scenario and handles checking both if the attack can be executed as well as clearing attack selection.

var tween;

var in_battle := false;
var info_out_end_pos;
var in_info_panel := false

func _ready() -> void:
	GlobalsAutoload.dropped_UI.connect(update_button);
	BattleAutoload.turn_changed.connect(turn_change);
	BattleAutoload.damage_dealt.connect(damage_popup);
	GlobalsAutoload.info_popup_open.connect(open_info_panel);
	$enemy_attack_spots.visible = false;
	$combo_thing.visible = false;
	$info_panel.visible = false;
	$info_displays.position.y = -400;
	$bottom_ui.position.y = 300;
	call_deferred("intro_tween");
	update_button();

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESCAPE") and in_info_panel and in_battle:
		close_info_panel()

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
	$combo_thing.modulate.a = 0;
	$combo_thing.visible = true;
	$attack_spots.visible = true;
	enemy_attack_preview()
	
	reset_tween();
	BattleAutoload.battle_intro_finished.emit();
	BattleAutoload.health_updated.emit()
	in_battle = true;
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($attack_spots, "position", Vector2(70,0), 0.5).from(Vector2(70,-380))
	tween.tween_property($combo_thing, "modulate:a", 1, 0.5)
	tween.tween_property($info_displays, "position:y", 0, 0.5).from(-400)
	tween.tween_property($bottom_ui, "position:y", 0, 0.5).from(300)

# Handles the behavior of pressing the attack button
func _on_attack_button_pressed() -> void:
	if is_attack_ready() && BattleAutoload.current_turn == 1:
		$"bottom_ui/attack button".disabled = true;
		reset_tween()
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"bottom_ui/attack button", "position:y", 450, 0.2).from(410)
		await tween.finished;
		tween_in_bars();
		hide_enemy_attack_preview();
		await tween.finished;
		GlobalsAutoload.timeout(0.2);
		await GlobalsAutoload.timer.timeout;
		BattleAutoload.update_turn_order();
		BattleAutoload.current_turn = 2
		print("current turn = 2 _ overlay")

# Handles the behavior of pressing the clear button
func _on_clear_chosen_attacks_pressed() -> void:
	if BattleAutoload.current_turn == 1:
		PlayerAutoload.attack_resources_in.clear()
		PlayerAutoload.attack_resources_in.resize(PlayerAutoload.attacks_per_turn)
		
		for i in $attack_spots.get_child_count():
			$attack_spots.get_child(i).reset();
		
		call_deferred("update_button");

# Returns if all player attack slots are filled
func is_attack_ready() -> bool:
	var ready_attack_count = 0;
	for attack in PlayerAutoload.attack_resources_in:
		if attack != null:
			ready_attack_count += 1;
	if ready_attack_count == PlayerAutoload.attack_resources_in.size():
		#print_rich("[color=yellow][font_size=30] the attack_ready returned true")
		return true
	#print_rich("[color=yellow][font_size=30] the attack_ready returned false; ready_attack_count = "+str(ready_attack_count)+", total slots = "+str(PlayerAutoload.attack_resources_in.size()))
	return false;

# Updates the attack button, tweening it in and updating its text if necessary
func update_button(_fuckts1 = null, _fuckts2 = null):
	print("update button")
	await BattleAutoload.done_updating_attacks;
	reset_tween();
	if is_attack_ready():
		call_deferred("update_button_speed_text")
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"bottom_ui/attack button", "position:y", 410, 0.5).from(700)
	else:
		tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
		tween.tween_property($"bottom_ui/attack button", "position:y", 700, 0.5)
	$"bottom_ui/attack button".disabled = not is_attack_ready();

func turn_change():
	if BattleAutoload.current_turn == 4:
		tween_out_bars();
		await tween.finished;
		GlobalsAutoload.timeout(0.4);
		await GlobalsAutoload.timer.timeout;
		enemy_attack_preview();
		speed_update();

# Un-disables the attack button after the turn resets
func speed_update():
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

func tween_in_bars():
	$bars.visible = true;
	reset_tween();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true);
	tween.tween_property($attack_spots, "position", Vector2(-300,20), 0.2)
	tween.tween_property($info_displays, "position:y", 90, 0.2)
	tween.tween_property($bottom_ui, "position:y", 300, 0.2)
	tween.tween_property($combo_thing, "modulate:a", 0, 0.5)
	tween.tween_property($bars/bottom_bar, "position:y", 568, 0.25).from(750)
	tween.tween_property($bars/top_bar, "position:y", 0, 0.25).from(-182)

func tween_out_bars():
	reset_tween();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true);
	tween.tween_property($bars/bottom_bar, "position:y", 750, 0.25)
	tween.tween_property($bars/top_bar, "position:y", -182, 0.25)
	tween.tween_property($attack_spots, "position", Vector2(70,20), 0.25)
	tween.tween_property($info_displays, "position:y", 0, 0.25)
	tween.tween_property($bottom_ui, "position:y", 0, 0.25)
	tween.tween_property($combo_thing, "modulate:a", 1, 0.5)
	await tween.finished;
	$bars.visible = false;

func enemy_attack_preview():
	for i in $enemy_attack_spots.get_child_count():
		$enemy_attack_spots.get_child(i).get_child(1).texture = BattleAutoload.enemy_node.attack_resources_in[i].icon_texture#the get child(0) is supposed to get the texture rect
		$enemy_attack_spots.get_child(i).scale = Vector2(0.01,0.01);
		$enemy_attack_spots.visible = true;
		var tween2 = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
		tween2.tween_property($enemy_attack_spots.get_child(i), "position:y", 150, 0.5);
		tween2.tween_property($enemy_attack_spots.get_child(i), "scale", Vector2(0.9,0.9), 0.5);

func hide_enemy_attack_preview():
	var tween2 = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	for i in $enemy_attack_spots.get_child_count():
		tween2.tween_property($enemy_attack_spots.get_child(i), "position:y", 250, 0.5);
		tween2.tween_property($enemy_attack_spots.get_child(i), "scale", Vector2(0.01,0.01), 0.5);
	await tween2.finished;
	$enemy_attack_spots.visible = false;

func damage_popup(damage : int, target, crit := false, evade := false):
	# Create Lambda function apply_popin
	var apply_popin = func (text : RichTextLabel):
		var offset_gravity = 50
		var pos_offset = Vector2(randi_range(-1 * offset_gravity, offset_gravity), randi_range(-1 * offset_gravity, offset_gravity))
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(text, "global_position", text.global_position + pos_offset, 0.5)#.from(text.global_position + pos_offset - Vector2(10,10));
	
	print("popup")
	var text = RichTextLabel.new();
	text.bbcode_enabled = true;
	text.fit_content = true;
	text.autowrap_mode = TextServer.AUTOWRAP_OFF;
	var color = "white"
	var fontsize = 25;
	if crit:
		color = "gold"
		fontsize = 40;
	if evade:
		color = "red"
		fontsize = 30;
		text.text = "[center][outline_size=" + str(fontsize/10) + "][outline_color=black][color=" + str(color) + "][font_size=" + str(fontsize) + "]Miss!"
	else:
		text.text = "[center][outline_size=" + str(fontsize/10) + "][outline_color=black][color=" + str(color) + "][font_size=" + str(fontsize) + "]" + str(damage);
	add_child(text);
	text.position = target.position;
	apply_popin.call(text);
	GlobalsAutoload.timeout(1);
	await GlobalsAutoload.timer.timeout;
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(text, "modulate:a", 0, 0.5);
	await tween.finished;
	text.queue_free()

func open_info_panel(target):
	if not in_info_panel and in_battle:
		if tween:
			tween.kill()
		in_info_panel = true;
		var stylebox = $info_panel.get_theme_stylebox("panel")
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true);
		tween.tween_property($info_displays, "position:y", -150, 0.5);
		tween.tween_property($bottom_ui, "position:y", 250, 0.5);
		if target.type == "Player":
			stylebox.border_color = Color("#007dff");
			$info_panel/name.text = "[center][font_size=30][color="+ str(target.name_color.to_html()) + "]" + target.player_name;
			$info_panel.position.x = -325
			info_out_end_pos = -325
			tween.tween_property($info_panel, "position:x", 50, 0.5);
		elif target.type == "Enemy":
			stylebox.border_color = Color("#c43e37");
			$info_panel/name.text = "[center][font_size=30][color="+ str(target.name_color.to_html()) + "]" + target.fish_name;
			$info_panel.position.x = 1152
			info_out_end_pos = 1152
			tween.tween_property($info_panel, "position:x", 777, 0.5);
		$info_panel/healthbar/number.text = "[center]" + str(target.stat_dictionary.health) + " / " + str(target.stat_dictionary.max_health)
		$info_panel/healthbar.max_value = target.stat_dictionary.max_health
		$info_panel/healthbar.value = target.stat_dictionary.health
		$info_panel/stats/text/str.text = "[center][font_size=25]" + str(target.stat_dictionary.strength)
		$info_panel/stats/text/def.text = "[center][font_size=25]" + str(target.stat_dictionary.defense)
		$info_panel/stats/text/agi.text = "[center][font_size=25]" + str(target.stat_dictionary.agility)
		$info_panel/stats/text/luk.text = "[center][font_size=25]" + str(target.stat_dictionary.luck)
		$info_panel/stats/text/eva.text = "[center][font_size=25]" + str(target.stat_dictionary.evasion)
		$info_panel.visible = true;
		tween.tween_property(GlobalsAutoload.camera, "global_position", target.position, 0.5);
		tween.tween_property(GlobalsAutoload.camera, "zoom", Vector2(1.5, 1.5), 0.5);
		tween.tween_property($attack_spots, "position:y", -380, 0.5)
		tween.tween_property($enemy_attack_spots, "position:y", -380, 0.5)

func close_info_panel():
	if tween:
		tween.kill()
	in_info_panel = false;
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true);
	tween.tween_property($info_displays, "position:y", 0, 0.5);
	tween.tween_property($bottom_ui, "position:y", 0, 0.5);
	tween.tween_property($info_panel, "position:x", info_out_end_pos, 0.5);
	tween.tween_property(GlobalsAutoload.camera, "global_position", Vector2(576, 324), 0.5);
	tween.tween_property(GlobalsAutoload.camera, "zoom", Vector2(1, 1), 0.5);
	tween.tween_property($attack_spots, "position:y", 0, 0.5)
	tween.tween_property($enemy_attack_spots, "position:y", 0, 0.5)
