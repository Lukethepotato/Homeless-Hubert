extends Node2D
@export var attack_resource_in: player_attack = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.dropped_UI.connect("dropped_UI") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func dropped_in_spot_signal_receive()
