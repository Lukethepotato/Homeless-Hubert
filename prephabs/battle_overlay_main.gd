extends CanvasLayer

# This script is attached to the clickable UI of the battle scenario and handles checking both if the attack can be executed as well as clearing attack selection.

# This script 100% can and should be refactored.

func _on_attack_button_pressed() -> void:
	if (PlayerAutoload.attack_resources_in[0] != null):
		GlobalsAutoload.current_turn = 2
		print("current turn = 2 _ overlay")

func _on_clear_choesen_attacks_pressed() -> void:
	GlobalsAutoload.clear_attack_selection.emit();
