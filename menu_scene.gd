extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_menu() -> void:
	$Panel.position = Vector2(627,17)
	$play_button.position = Vector2(651, 51)
	$options_button.position = Vector2(651, 197)
	$credits_button.position = Vector2(651, 341)
	$exit_button.position = Vector2(651, 484)


func _on_play_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
