extends Node2D
@export var health: int = 20 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.enemy_node = self # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
