extends Control
@export var setTextureTo: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TextureRect.texture = setTextureTo# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
