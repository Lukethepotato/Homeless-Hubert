extends Sprite2D
signal dragDrop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("Left Click"):
		dragDrop.emit()
		queue_free()
