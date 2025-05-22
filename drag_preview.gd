extends Sprite2D
signal dragDrop

# This script is attached to the icon preview of a drag node. It handles both position and deletion in the process function.

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("LMB"):
		dragDrop.emit()
		queue_free()
