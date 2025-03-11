extends AnimationPlayer
var attack_in_turn_index_finished: int = 0
var attack_in_turn_index_started: int = 0
var combo_done_this_turn = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalsAutoload.current_turn == PlayerAutoload.goes_on_turn:
		_play_attack()
		

func _play_attack():
	if combo_checking2() == null:
		if attack_in_turn_index_finished < PlayerAutoload.attack_resources_in.size() && PlayerAutoload.attack_resources_in[attack_in_turn_index_finished] != null && current_animation == "":
			play(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished].animation_name)
			PlayerAutoload.attack_history.append(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished])
			attack_in_turn_index_finished += 1
			print("play atatck")
		else:
			attack_in_turn_index_finished = 0
			GlobalsAutoload.current_turn += 1
			combo_done_this_turn =false
			print("attacks finished")
	else:
		play(combo_checking2().animation_name)
	


func _on_animation_finished(anim_name: StringName) -> void:
	_play_attack()
	
func combo_checking2() -> player_combo:
	for i in GlobalsAutoload.combo_node.combo_resources.size():
		var attack_history_with_chosen_attacks = PlayerAutoload.attack_history
		attack_history_with_chosen_attacks.append_array(PlayerAutoload.attack_resources_in)
		
		var attack_history_cut = attack_history_with_chosen_attacks.slice(PlayerAutoload.attack_history.size()-1, attack_history_with_chosen_attacks.size())
		if attack_history_cut == GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo:
			print("combo returned")
			return GlobalsAutoload.combo_node.combo_resources[i]
			
	return null
	
func combo_checking() -> player_combo:
	for i in GlobalsAutoload.combo_node.combo_resources.size():
		var times_while_loop_ran: int = 0
		for b in range(GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.size()-1, -1,-1):
			print("ran through " + GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo[b].animation_name)
			if times_while_loop_ran > PlayerAutoload.attack_history.size():
				break
			times_while_loop_ran += 1
			if GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo[b] != PlayerAutoload.attack_history[PlayerAutoload.attack_history.size()- times_while_loop_ran]:
				i += 1
				break
				print("checked combo not done attacks")
			elif b == 0:
				print(GlobalsAutoload.combo_node.combo_resources[i].animation_name)
				return GlobalsAutoload.combo_node.combo_resources[i]
	return null
			
		

func _on_animation_started(anim_name: StringName) -> void:
	if (PlayerAutoload.attack_resources_in.size() > attack_in_turn_index_started) && PlayerAutoload.attack_resources_in[0] != null:
		#PlayerAutoload.attack_history.append(PlayerAutoload.attack_resources_in[attack_in_turn_index_started])
		print("animation start")
		#check if a combo was done here and if so dont play the next attack instead play combo
			
		
		
		attack_in_turn_index_started += 1
	else:
		attack_in_turn_index_started = 0
