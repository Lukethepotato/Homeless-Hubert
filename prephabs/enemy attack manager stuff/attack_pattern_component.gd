extends Node2D
@export var attack_pattern: Array[enemy_attack]
var index_on: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _attack_verdict() -> enemy_attack:
	if index_on == attack_pattern.size() -1:
		index_on = 0
		return attack_pattern[index_on]
	else:
		return attack_pattern[index_on]
		#get_parent()._final_enemy_attack_choose(true, attack_pattern[0])
