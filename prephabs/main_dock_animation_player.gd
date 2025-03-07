extends AnimationPlayer
var attack_in_turn_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalsAutoload.current_turn == PlayerAutoload.goes_on_turn:
		play(PlayerAutoload.attack_resources_in[0].animation_name)
		


func _on_animation_finished(anim_name: StringName) -> void:
	if (PlayerAutoload.attack_resources_in.size() > attack_in_turn_index):
		PlayerAutoload.attack_history.append(PlayerAutoload.attack_resources_in[attack_in_turn_index])
		
		#check if a combo was done here and if so dont play the next attack in turn index play combo
		
		play(PlayerAutoload.attack_resources_in[attack_in_turn_index].animation_name)
		attack_in_turn_index += 1
		print("attack played")
		
	else:
		attack_in_turn_index = 0
		GlobalsAutoload.current_turn += 1
