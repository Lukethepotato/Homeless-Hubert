extends AnimationPlayer
var attack_in_turn_index_finished: int = 0
var attack_in_turn_index_started: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalsAutoload.current_turn == PlayerAutoload.goes_on_turn:
		play(PlayerAutoload.attack_resources_in[0].animation_name)
		


func _on_animation_finished(anim_name: StringName) -> void:
	if (PlayerAutoload.attack_resources_in.size() > attack_in_turn_index_finished) && PlayerAutoload.attack_resources_in[0] != null:
		play(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished].animation_name)
		attack_in_turn_index_finished += 1
		print("attack played")
		
	else:
		attack_in_turn_index_finished = 0
		GlobalsAutoload.current_turn += 1
		
	
func combo_checking() -> player_combo:
	for i in GlobalsAutoload.combo_node.combo_resources.size():
		var times_while_loop_ran: int = 0
		for b in range(GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.size()-1, -1,-1):
			print("ran through " + str(b))
			times_while_loop_ran += 1
			if b == 0:
				print(GlobalsAutoload.combo_node.combo_resources[i].animation_name)
				return GlobalsAutoload.combo_node.combo_resources[i]
			elif GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo[b] != PlayerAutoload.attack_history[PlayerAutoload.attack_history.size()- times_while_loop_ran]:
				i += 1
				break
				print("checked combo not done attacks")
	return null
			
		

func _on_animation_started(anim_name: StringName) -> void:
	if (PlayerAutoload.attack_resources_in.size() > attack_in_turn_index_started) && PlayerAutoload.attack_resources_in[0] != null:
		PlayerAutoload.attack_history.append(PlayerAutoload.attack_resources_in[attack_in_turn_index_started])
		print("animation start")
		#check if a combo was done here and if so dont play the next attack instead play combo
		var temp_combo_check = combo_checking()
		if temp_combo_check != null:
			play(temp_combo_check.animation_name)
			
		
		
		attack_in_turn_index_started += 1
	else:
		attack_in_turn_index_started = 0
