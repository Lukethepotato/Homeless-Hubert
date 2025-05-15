extends Node2D

# This is a script (Resource?) that contains an enemy's given attack pattern. It also has a function _attack_verdict which returns the next attack the enemy will use.

@export var attack_pattern: Array[attack_parent]
var index_on: int = 0

# Returns what attack the enemy is going to use according to its attack pattern
func _attack_verdict() -> attack_parent:
	if index_on == attack_pattern.size() -1:
		index_on = 0
		return attack_pattern[index_on]
	else:
		return attack_pattern[index_on]
		#get_parent()._final_attack_parent_choose(true, attack_pattern[0])
