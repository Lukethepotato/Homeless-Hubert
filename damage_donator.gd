extends Node2D

# This script contains a single "damage donation" function which takes in an integer as the damage dealt in a given attack. The function itself checks which character should receive the damage.

# Maybe rewrite to be less rigid? What if we want an attack to do self damage?

func _damage_donation(amount: int):
	if GlobalsAutoload.current_turn == GlobalsAutoload.enemy_goes_on_turn:
		PlayerAutoload.health -= amount
		
	elif GlobalsAutoload.current_turn == PlayerAutoload.goes_on_turn:
		GlobalsAutoload.enemy_node.health -= amount
