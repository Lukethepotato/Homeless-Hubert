extends Control
@export var combo: player_combo

@export var attacks_done_amount := 0

@export var before_bbCode: String
@export var after_bbCode: String
var checkpoint := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.connect("turn_changed", _reverse_combo_checking)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text: String =""
	
	if attacks_done_amount > 0:
		text= before_bbCode
		
	
	for i in combo.attacks_in_combo.size():
		#text += combo.attacks_in_combo[i].name
		text += combo.attacks_in_combo[i].name

		
		if attacks_done_amount-1 == i:
			text += after_bbCode
			
	$RichTextLabel.text = text 
	

func _reverse_combo_checking():
	attacks_done_amount = 0
	var combo_reverse_index = combo.attacks_in_combo.size() -1
	if PlayerAutoload.attack_history.size() > 0:
		for i in range(PlayerAutoload.attack_history.size() -1, -1, -1):
			if combo.attacks_in_combo[combo_reverse_index] == PlayerAutoload.attack_history[i]:
				attacks_done_amount += 1
			elif combo.attacks_in_combo[combo_reverse_index] != PlayerAutoload.attack_history[i]:
				if checkpoint != i:
					checkpoint = i
					attacks_done_amount = 0
					
				break
			combo_reverse_index -= 1
		
		
