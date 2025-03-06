extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalsAutoload.current_turn == 3:
		play(PlayerAutoload.attack_resources_in[0].animation_name)
		


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == PlayerAutoload.attack_resources_in[0].animation_name:
		play(PlayerAutoload.attack_resources_in[1].animation_name)
		
	elif anim_name == PlayerAutoload.attack_resources_in[1].animation_name:
		GlobalsAutoload.current_turn = 4 # Replace with function body.
