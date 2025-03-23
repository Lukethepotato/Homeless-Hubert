extends Control
@export var combo: player_combo
var attack_history_with_chosen_attacks
var attack_history_cut

@export var order_done_in_combo := 0

@export var before_bbCode: String
@export var after_bbCode: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text: String = before_bbCode
	for i in combo.attacks_in_combo.size():
		text += combo.attacks_in_combo[i].name

		if order_done_in_combo == i:
			text += after_bbCode
		

	$RichTextLabel.text = text 

func combo_checking():
	for i in combo.attacks_in_combo.size():
		var reset_choice: bool
		if i == 0:
			reset_choice = true
		else:
			reset_choice = false
		if combo_checking1(combo.attacks_in_combo[i], reset_choice) != combo:
			order_done_in_combo += 1
			
	PlayerAutoload.attack_history.slice(PlayerAutoload.attack_history.size())
	
	#return GlobalsAutoload.combo_node.combo_resources[i]
	
func combo_checking1(attack_to_check: player_attack, reset := true) -> player_combo:
	for i in GlobalsAutoload.combo_node.combo_resources.size():
		
		if reset:
			attack_history_with_chosen_attacks = PlayerAutoload.attack_history.duplicate()
		
		attack_history_with_chosen_attacks.append(attack_to_check)
		
		#var attack_history_cut: Array[player_attack]
		attack_history_cut = attack_history_with_chosen_attacks.slice(PlayerAutoload.attack_history.size()-1 - GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.size()-1-1, attack_history_with_chosen_attacks.size())
		if attack_history_cut.hash() == GlobalsAutoload.combo_node.combo_resources[i].attacks_in_combo.hash():
			return GlobalsAutoload.combo_node.combo_resources[i]
	return null
