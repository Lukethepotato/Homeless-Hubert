extends Control
@export var combo: player_combo
var attack_history_cut

@export var attacks_done_in_combo := 0

@export var before_bbCode: String
@export var after_bbCode: String
var combo_slice


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.connect("turn_changed", _slice_checking)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text: String =""
	
	if attacks_done_in_combo > 0:
		text= before_bbCode
		
	
	for i in combo.attacks_in_combo.size():
		#text += combo.attacks_in_combo[i].name
		text += combo.attacks_in_combo[i].name

		
		if attacks_done_in_combo-1 == i:
			text += after_bbCode
			
		_slice_checking()

	$RichTextLabel.text = text 
	
func _slice_checking():
	for i in combo.attacks_in_combo.size():
		var attack_hist_size = PlayerAutoload.attack_history.size()
		var beebo = PlayerAutoload.attack_history.duplicate()
		var combo_attacks_size = combo.attacks_in_combo.size()
		
		if combo_attacks_size < attack_hist_size:
			combo_attacks_size = attack_hist_size
		attack_history_cut = beebo.slice(attack_hist_size - combo_attacks_size,attack_hist_size - combo_attacks_size + i)
		print("begin value = " + str(attack_hist_size - combo_attacks_size) + "end value = " + str(attack_hist_size - combo.attacks_in_combo.size() + i))
		
		
		combo_slice = combo.attacks_in_combo.slice(0,i+1)
		
		if attack_history_cut == combo_slice:
			attacks_done_in_combo = i +1
			print("checked and history fit in combo up to " + str(attacks_done_in_combo))
			
		elif attack_history_cut != combo_slice:
			if attack_history_cut.size() < combo.attacks_in_combo.size():
				print("checked ____history to small at"+ str(attacks_done_in_combo))
				break
			else:
				attacks_done_in_combo = 0
				print("checked ____not right attack at"+ str(attacks_done_in_combo))
				break
	
