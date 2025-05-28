extends Control
@export var combo: player_combo

@export var attacks_done_amount := 0

@export var before_bbCode: String
@export var after_bbCode: String
var checkpoint := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BattleAutoload.connect("turn_changed", _reverse_combo_checking)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text: String =""
	
	if attacks_done_amount > 0:
		text = before_bbCode
		
	
	for i in combo.attacks_in_combo.size():
		#text += combo.attacks_in_combo[i].name
		text += combo.attacks_in_combo[i].name

		
		if attacks_done_amount-1 == i:
			text += after_bbCode
			
	$RichTextLabel.text = text 

func _reverse_combo_checking(set_checkpoint:int = 0):
	attacks_done_amount = 0
	var combo_index: int = 0
	if PlayerAutoload.attack_history.size() > 0:
		for player_attack_index in range(set_checkpoint, PlayerAutoload.attack_history.size(),1):
			print("at player attack index" + str(player_attack_index))
		
			if PlayerAutoload.attack_history[player_attack_index] == combo.attacks_in_combo[combo_index]:
				attacks_done_amount += 1
				print("attack found same")
				
			else:
				print("reseting checkpoint at: "+ str(player_attack_index +1) )
				_reverse_combo_checking(player_attack_index +1)
				break
			
			prints("attacks same = " + str(attacks_done_amount))
			combo_index += 1
		
