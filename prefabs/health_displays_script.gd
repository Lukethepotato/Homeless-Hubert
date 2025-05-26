extends Control

# This script updates the player health text every frame.

var tween;

func _ready() -> void:
	BattleAutoload.health_updated.connect(update_health)
	$player_info/player_healthbar.value = PlayerAutoload.stat_dictionary.health;
	$player_info/player_healthbar.max_value = PlayerAutoload.stat_dictionary.max_health;
	$enemy_info/enemy_healthbar.value = BattleAutoload.enemy_node.stat_dictionary.health;
	$enemy_info/enemy_healthbar.max_value = BattleAutoload.enemy_node.stat_dictionary.max_health;

# Updates the health bars of both battle participants
func update_health() -> void:
	$player_info/player_healthbar/number.text = "[center]" + str(PlayerAutoload.stat_dictionary.health) + " / " + str(PlayerAutoload.stat_dictionary.max_health)
	$enemy_info/enemy_healthbar/number.text = "[center]" + str(BattleAutoload.enemy_node.stat_dictionary.health) + " / " + str(BattleAutoload.enemy_node.stat_dictionary.max_health)
	if tween:
		tween.kill();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($player_info/player_healthbar, "value", PlayerAutoload.stat_dictionary.health, 0.5);
	tween.tween_property($enemy_info/enemy_healthbar, "value", BattleAutoload.enemy_node.stat_dictionary.health, 0.5);

# Fetches the names of both battle participants
func fetch_names():
	$player_info/player_name.text = "[left][font_size=25][color="+ str(PlayerAutoload.name_color.to_html()) + "]" + PlayerAutoload.player_name;
	$enemy_info/enemy_name.text = "[right][font_size=25][color="+ str(BattleAutoload.enemy_node.name_color.to_html()) + "]" + BattleAutoload.enemy_node.fish_name;
	
