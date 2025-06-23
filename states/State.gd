extends Node
class_name State
#this is the state script
#all of the states extend this script
#they all follow the same format of functions just with diffrent stuff in inside
#that way when the finite state machine calls it, no matter what state it is it call enter

@export var attack_pattern_set:Array[attack_parent] #this is the attack pattern set on "_set_attack_pattern"
@export var attack_deciders_to_disable: Array[NodePath] # This disables the decided children of enemy attack manager
@export var set_fallback_attack: attack_parent

func _process(delta: float) -> void:
	pass
	
func enter():
	%"Enemy attack manager".fallback_attack = set_fallback_attack
	
	for i in %"Enemy attack manager".get_children():
		i.disabled = false
	#first turns on all attack managers
	
	for i in attack_deciders_to_disable.size():
		get_node(attack_deciders_to_disable[i]).disabled = true
	#then disables the desired ones 
	
	
func exit():
	pass
