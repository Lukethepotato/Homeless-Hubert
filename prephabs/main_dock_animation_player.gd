extends AnimationPlayer

# This script handles the animations and attacking for the player character.

var attack_in_turn_index_finished: int = 0
@export var attack_history_cut: Array[player_attack]
@export var attack_history_with_chosen_attacks: Array[player_attack]

func _process(delta: float) -> void:
	if GlobalsAutoload.current_turn == PlayerAutoload.goes_on_turn:	
		_play_attack()

# This function calls back to the combo checking function in order to play the chosen attack. If a combo is found, the animation played changes if the combo would be completed by the attack.
func _play_attack():
	if combo_checking() == null:
		if attack_in_turn_index_finished < PlayerAutoload.attack_resources_in.size()-1 && PlayerAutoload.attack_resources_in[attack_in_turn_index_finished] != null && current_animation == "":
			play(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished].animation_name)
			PlayerAutoload.attack_history.append(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished])
			attack_in_turn_index_finished += 1
			print("play atatck")
		else:
			attack_in_turn_index_finished = 0
			GlobalsAutoload.current_turn += 1
			print("attacks finished")
	else:
		if attack_in_turn_index_finished < PlayerAutoload.attack_resources_in.size() -1:
			play(combo_checking().animation_name)
			print("combo attack done")
			PlayerAutoload.attack_history.clear()
			attack_in_turn_index_finished += 1
		else:
			attack_in_turn_index_finished = 0
			GlobalsAutoload.current_turn += 1
			print("attacks finished")

func _on_animation_finished(anim_name: StringName) -> void:
	_play_attack()

# This function checks if there are any completable combos and returns the proper combo if true.
func combo_checking() -> player_combo:
	for i in GlobalsAutoload.combo_node.combo_resources.size():
		attack_history_with_chosen_attacks = PlayerAutoload.attack_history.duplicate()
		attack_history_with_chosen_attacks.append(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished])
		
		#var attack_history_cut: Array[player_attack]
		attack_history_cut = attack_history_with_chosen_attacks.slice(PlayerAutoload.attack_history.size()-1 - GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.size()-1-1, attack_history_with_chosen_attacks.size())
		if attack_history_cut.hash() == GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.hash():
			return GlobalsAutoload.combo_node.combo_resources[i]
	return null
