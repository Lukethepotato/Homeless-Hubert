extends Node2D

# This script contains a single "damage donation" function which takes in an integer as the damage dealt in a given attack. The function itself checks which character should receive the damage.

# Maybe rewrite to be less rigid? What if we want an attack to do self damage?
# it can now,  you now happy cunt?

func _damage_donation(player_damaged: bool, amount: int):
	#The player_damaged parameter determines who the damage will be donated to 
	#false to damage enemy, true to damage player
	
	if player_damaged:
		var enemy_attack_hist =  GlobalsAutoload.enemy_node.attack_history
		if GlobalsAutoload.enemy_node.attack_history[enemy_attack_hist.size()- 1].hit_region != PlayerAutoload.current_block: 
			PlayerAutoload.health -= amount
		
	elif player_damaged == false:
		if PlayerAutoload.attack_history[PlayerAutoload.attack_history.size() -1].hit_region != GlobalsAutoload.enemy_node.current_block:
			GlobalsAutoload.enemy_node.health -= amount
		
