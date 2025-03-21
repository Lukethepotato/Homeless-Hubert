extends CanvasLayer

# This script is attached to the clickable UI of the battle scenario and handles checking both if the attack can be executed as well as clearing attack selection.

#func _ready() -> void:
	#GlobalsAutoload.dropped_UI.connect(update_button)
	#update_button();

func _on_attack_button_pressed() -> void:
	if is_attack_ready() && GlobalsAutoload.current_turn == 1:
		GlobalsAutoload.current_turn = 2
		print("current turn = 2 _ overlay")

func _on_clear_chosen_attacks_pressed() -> void:
	GlobalsAutoload.clear_attack_selection.emit();
	#call_deferred("update_button");

func is_attack_ready() -> bool:
	#for attack in PlayerAutoload.attack_resources_in:
		#if attack != null:
			#return true;
	#return false;
	return (PlayerAutoload.attack_resources_in[0] != null)

#func update_button(_fuckts1 = null, _fuckts2 = null):
	#print("update button")
	#$"attack button".disabled = not is_attack_ready();
