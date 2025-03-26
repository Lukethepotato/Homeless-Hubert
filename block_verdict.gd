extends Node2D
@export var block_chance: float = 5
#number must be from 0 to 10, the higher the more likly they block
@export var block_inclination: float = 5
#number must be from 0 to 10, higher means more likly high block. The lower means more likly low block

@export var blocks: Array[enemy_attack]
#low block is the 0 index and high is the 1 index

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _attack_verdict() -> enemy_attack:
	var rand_numb = randf_range(0, 10)
	if rand_numb > block_chance:
		rand_numb = randf_range(0,10)
		
		if block_inclination > rand_numb:
			return blocks[1]
			#returns high block
		else:
			return blocks[0]
			#returns low block
	else:
		return null
		
	
	
