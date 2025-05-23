extends Camera2D

# This script handles the logic of the camera in the main_dock scene as well as when battle begins.

var tween;
@export var randomStrength: float = 30.0
@export var shakeFade: float = 5
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _ready() -> void:
	GlobalsAutoload.shake_camera.connect(apply_shake)
	GlobalsAutoload.battle_start.connect(battle_camera)
	GlobalsAutoload.battle_end.connect(end_battle_camera)

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
	offset = randomOffset()
	#position = playerpos;

func apply_shake(shakeAmount: float):
	shake_strength = shakeAmount
	#call apply_shake("insert shakeAmount here") to make camera shake
	#40 is a good starting number for shakeAmount

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
	
func battle_camera():
	var new_position = GlobalsAutoload.current_battle_scenario.get_node("midpoint").global_position;
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
	tween.tween_property(self, "global_position", new_position, 0.25);

func end_battle_camera():
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD);
	tween.tween_property(self, "global_position", get_parent().global_position, 0.25);
