extends AnimationPlayer

# This script handles the animations and attacking for the player character.

var attack_in_turn_index_finished: int = 0
@export var attack_history_cut: Array[attack_parent]
@export var attack_history_with_chosen_attacks: Array[attack_parent]
@export var is_forward: bool = false


func _ready():
	GlobalsAutoload.turn_changed.connect(_play_attack)
	GlobalsAutoload.current_turn_reset.connect(_turn_rest)
	
func _turn_rest():
	pass

func _process(delta: float):
	BattleAutoload._non_attack_animations(self, %Ailments_parent, "player")

func _play_attack():
	if GlobalsAutoload.current_turn == PlayerAutoload.goes_on_turn and GlobalsAutoload.state == GlobalsAutoload.game_states.IN_BATTLE:
		#this function is called on turn change
		#so this if makes sure its the players turn and the state is right
		if PlayerAutoload.attack_resources_in[0].enables_rush:
			rush("forward")
			await animation_finished
		#rush forward is called then once the animation is over the rest of the stuff will play out
		
		while attack_in_turn_index_finished < PlayerAutoload.attack_resources_in.size():
		#this while loop is where the attack is played and it runs once for each attack resource spot
		
			var animation_to_play: String
			#this string is changed to the upcoming attack's animation name
			if combo_checking() == null:
				animation_to_play = PlayerAutoload.attack_resources_in[attack_in_turn_index_finished].animation_name
			else:
				animation_to_play = combo_checking().animation_name
				#if combo checking returns somthing. The "animation_to_play" string gets set to the combo's animation name instead
			if PlayerAutoload.attack_resources_in[attack_in_turn_index_finished].enables_rush == false && is_forward:
				rush("back")
				await animation_finished
			elif PlayerAutoload.attack_resources_in[attack_in_turn_index_finished].enables_rush == true && is_forward == false:
				rush("forward")
				await animation_finished
				
			play(animation_to_play)
			PlayerAutoload.attack_history.append(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished])
			PlayerAutoload.current_block = PlayerAutoload.attack_resources_in[attack_in_turn_index_finished].gives_block
			PlayerAutoload.current_combo = combo_checking()
			attack_in_turn_index_finished += 1
			await animation_finished
			#once the loop is over it waits to loop again until the current attack anim is done
		
		if is_forward:
			rush("back")
		GlobalsAutoload.current_turn += 1
		attack_in_turn_index_finished = 0
		#once everything is all done and all the little varibles are happy and cozy the player rushes back

		
func rush(option: String):
	if option == "forward":
		print_rich("[color=gold][wave amp=50.0 freq=5.0][font_size=20] rush forward");
		play("hubert_rush_forward")
		is_forward = true
	elif option == "back":
		print_rich("[color=gold][wave amp=50.0 freq=5.0][font_size=20] rush back");
		play("hubert_rush_back")
		is_forward = false


# This function checks idf there are any completable combos and returns the proper combo if true.
func combo_checking() -> player_combo:
	for i in GlobalsAutoload.combo_node.combo_resources.size():
		attack_history_with_chosen_attacks = PlayerAutoload.attack_history.duplicate()
		if (attack_in_turn_index_finished < PlayerAutoload.attack_resources_in.size()):
			attack_history_with_chosen_attacks.append(PlayerAutoload.attack_resources_in[attack_in_turn_index_finished])
		
		attack_history_cut = attack_history_with_chosen_attacks.slice(attack_history_with_chosen_attacks.size() - GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.size(), attack_history_with_chosen_attacks.size())
		if attack_history_cut.hash() == GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.hash():
			return GlobalsAutoload.combo_node.combo_resources[i]
	return null
