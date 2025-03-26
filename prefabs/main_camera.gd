extends Camera2D

# This script handles the logic of the camera in the main_dock scene as well as when battle begins.

var tween;

func _ready() -> void:
	GlobalsAutoload.battle_start.connect(battle_camera)

func battle_camera():
	var new_position = GlobalsAutoload.current_battle_scenario.get_node("midpoint").global_position;
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
	tween.tween_property(self, "global_position", new_position, 0.25);

func end_battle_camera():
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
	tween.tween_property(self, "global_position", get_parent().global_position, 0.25);
