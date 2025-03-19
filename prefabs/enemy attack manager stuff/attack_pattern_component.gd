extends Node2D

# This is a script (Resource?) that contains an enemy's given attack pattern. It also has a function _attack_verdict which returns the next attack the enemy will use.

@export var attack_pattern: Array[enemy_attack]
var index_on: int = 0

func _attack_verdict() -> enemy_attack:
	if index_on == attack_pattern.size() -1:
		index_on = 0
		return attack_pattern[index_on]
	else:
		return attack_pattern[index_on]
		#get_parent()._final_enemy_attack_choose(true, attack_pattern[0])
