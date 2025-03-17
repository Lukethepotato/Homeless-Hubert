extends CharacterBody2D

@export var speed := 3
@export var frame := 1
@export var animation := "Idle"


func _process(delta: float) -> void:
	if GlobalsAutoload.state == GlobalsAutoload.game_states.ROAMING:
		var axis = Input.get_axis("LEFT", "RIGHT");
		velocity.x = axis * speed * 100
		move_and_slide();
	elif GlobalsAutoload.state == GlobalsAutoload.game_states.IN_BATTLE:
		update_sprites();

func update_sprites():
	$Hubert_Sprites.frame = frame;
	$Hubert_Sprites.animation = animation;
