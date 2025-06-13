extends Node
class_name State
#this is the state script
#all of the states extend this script
#they all follow the same format of functions just with diffrent stuff in inside
#that way when the finite state machine calls it, no matter what state it is it call enter

@export var attack_pattern_set:Array[attack_parent] #this is the attack pattern set on "_set_attack_pattern"
@export var attack_deciders_to_disable: Array[NodePath] # This disables the decided children of enemy attack manager

func _process(delta: float) -> void:
	pass
	
#sets the attack pattern
#can be called in your states its up to you (:
func _set_attack_pattern():
	%"Attack pattern".attack_pattern = attack_pattern_set

func enter():
	pass
