extends CharacterBody2D

# This script handles Hubert's movement, gravity, and sprites.

@export var speed := 3
@export var jump_power := 2

func _process(delta: float) -> void:
	velocity.x = 0;
	if GlobalsAutoload.state == GlobalsAutoload.game_states.ROAMING:
		var axis = Input.get_axis("LEFT", "RIGHT");
		velocity.x = axis * speed * 100;
		if is_on_floor() and Input.is_action_just_pressed("UP"):
			velocity.y = -1 * jump_power * 100;
	apply_gravity(delta);
	move_and_slide();

# Updates Hubert's y-velocity according to the Project's gravity setting
func apply_gravity(delta: float):
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if not is_on_floor():
		velocity.y += gravity * delta;

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB") and GlobalsAutoload.state == GlobalsAutoload.game_states.IN_BATTLE:
		GlobalsAutoload.info_popup_open.emit(PlayerAutoload)
