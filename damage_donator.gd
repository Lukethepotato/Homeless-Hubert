extends Node2D

# This script contains a single "damage donation" function which takes in an integer as the damage dealt in a given attack. The function itself checks which character should receive the damage.

# I rewrote this sorry; User is who is using the attack, Target is the target of the attack, Base_dmg is the attack base damage, Can_crit is if the attack can crit, 
# Guaranteed_hit is if the attack can miss

func _damage_donation(user : String, target : String, base_dmg: int, can_crit := true, guaranteed_hit := false):
	var perpetrator;
	var victim;
	
	# This section figures out what exactly the User and Target strings denote
	if (user.to_lower() == "player"):
		perpetrator = PlayerAutoload;
	else:
		perpetrator = GlobalsAutoload.enemy_node;
	if (target.to_lower() == "player"):
		victim = PlayerAutoload;
	else:
		victim = GlobalsAutoload.enemy_node;
	
	var damage_to_deal = BattleAutoload.calculate_damage(base_dmg, perpetrator, victim, can_crit, guaranteed_hit);
	
	if perpetrator != victim:
		if perpetrator.attack_history[perpetrator.attack_history.size()- 1].hit_region != victim.current_block: 
			victim.health -= damage_to_deal;
	else:
		victim.health -= damage_to_deal;
	
	GlobalsAutoload.health_updated.emit();
