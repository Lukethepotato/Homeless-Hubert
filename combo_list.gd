extends Control
@export var instructions_phab: PackedScene
var last_ones_spot: float =0.0

@export var incrementation: float

func _ready() -> void:
	for i in BattleAutoload.all_player_combos.size():
		var instruction = instructions_phab.instantiate()
		add_child(instruction)
		instruction.combo = BattleAutoload.all_player_combos[i]
		if i > 0:
			instruction.position = Vector2(0, last_ones_spot + incrementation)
		last_ones_spot = instruction.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
