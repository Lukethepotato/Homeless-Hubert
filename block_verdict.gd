extends attack_decider_parent
class_name block_verdict

@export var block_chance: float = 5
#number must be from 0 to 10, the higher the more likly they block

@export var blocks: Array[attack_parent]
#low block is the 0 index and high is the 1 index

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _attack_verdict() -> attack_parent:
	var rand_numb = randf_range(0, 10)
	if rand_numb > block_chance && %Ailments_parent._can_change_block():
	#this decides which block will be done
		rand_numb = randf_range(0,10)
		
		if BattleAutoload.enemy_node.block_inclination > rand_numb:
		#this decides what type of block will be done
		#Higher block inclin: high block more likly, lower block inclin: low blcok more likly
			if  BattleAutoload.enemy_node.current_block == blocks[1].gives_block:
				#print("blocks same so no dice")
				return null
				#if its already in that block it wont return it
			else:
				return blocks[1]
				#returns high block
		else:
			if BattleAutoload.enemy_node.current_block == blocks[0].gives_block:
				#print("blocks same so no dice")
				return null
				#if its already in that block it wont return it
			else:
				return blocks[0]
				#returns low block
	else:
		return null
		
	
	
