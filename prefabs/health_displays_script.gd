extends Control

# This script updates the player health text every frame.

var tween;

func _ready() -> void:
	GlobalsAutoload.health_updated.connect(update_health)
	$player_info/player_healthbar.value = PlayerAutoload.health;
	$player_info/player_healthbar.max_value = PlayerAutoload.max_health;
	$enemy_info/enemy_healthbar.value = GlobalsAutoload.enemy_node.health;
	$enemy_info/enemy_healthbar.max_value = GlobalsAutoload.enemy_node.max_health;

# Updates the health bars of both battle participants
func update_health() -> void:
	$player_info/player_healthbar/number.text = "[center]" + str(PlayerAutoload.health) + " / " + str(PlayerAutoload.max_health)
	$enemy_info/enemy_healthbar/number.text = "[center]" + str(GlobalsAutoload.enemy_node.health) + " / " + str(GlobalsAutoload.enemy_node.max_health)
	if tween:
		tween.kill();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($player_info/player_healthbar, "value", PlayerAutoload.health, 0.5);
	tween.tween_property($enemy_info/enemy_healthbar, "value", GlobalsAutoload.enemy_node.health, 0.5);

# Fetches the names of both battle participants
func fetch_names():
	$player_info/player_name.text = "[left][font_size=25][color="+ str(PlayerAutoload.name_color.to_html()) + "]" + PlayerAutoload.player_name;
	$enemy_info/enemy_name.text = "[right][font_size=25][color="+ str(GlobalsAutoload.enemy_node.name_color.to_html()) + "]" + GlobalsAutoload.enemy_node.fish_name;
