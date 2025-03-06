extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_attack_button_pressed() -> void:
	if (PlayerAutoload.attack_resources_in[0] != null):
		GlobalsAutoload.current_turn = 3
		 # Replace with function body.


func _on_clear_choesen_attacks_pressed() -> void:
	GlobalsAutoload.clear_attack_selection.emit() # Replace with function body.
