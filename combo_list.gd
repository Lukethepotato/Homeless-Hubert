extends Control
@export var instructions_phab: PackedScene
var last_ones_spot: float =0.0

@export var incrementation: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in GlobalsAutoload.all_player_combos.size():
		var instruction = instructions_phab.instantiate() # Create a new Sprite2D.
		add_child(instruction)
		instruction.position = Vector2(0, last_ones_spot + incrementation)
		last_ones_spot = instruction.position.y
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
