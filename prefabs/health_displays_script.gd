extends Control

# This script updates the player health text every frame.

var tween;

func _ready() -> void:
	GlobalsAutoload.health_updated.connect(update_health)
	$"Player healthbar".value = PlayerAutoload.health;
	$"Player healthbar".max_value = PlayerAutoload.max_health;
	$"Enemy healthbar".value = GlobalsAutoload.enemy_node.health;
	$"Enemy healthbar".max_value = GlobalsAutoload.enemy_node.max_health;

func update_health() -> void:
	$"Player healthbar/number".text = "[center]" + str(PlayerAutoload.health) + " / " + str(PlayerAutoload.max_health)
	$"Enemy healthbar/number".text = "[center]" + str(GlobalsAutoload.enemy_node.health) + " / " + str(GlobalsAutoload.enemy_node.max_health)
	if tween:
		tween.kill();
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true);
	tween.tween_property($"Player healthbar", "value", PlayerAutoload.health, 0.5);
	tween.tween_property($"Enemy healthbar", "value", GlobalsAutoload.enemy_node.health, 0.5);
