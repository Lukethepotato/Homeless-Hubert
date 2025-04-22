extends Node2D
@export var camera_path: NodePath

# This script contains a single "damage donation" function which takes in an integer as the damage dealt in a given attack. The function itself checks which character should receive the damage.

# User is who is using the attack, Target is the target of the attack, Base_dmg is the attack base damage, Can_crit is if the attack can crit, 
# Guaranteed_hit is if the attack can miss

func _damage_donation(user : String, target : String, base_dmg: int, combo : player_combo = null, can_crit := true, guaranteed_hit := false):
	var roles = BattleAutoload.convert_strs_to_attack_roles(user, target)
	
	var damage_to_deal = BattleAutoload.calculate_damage(base_dmg, roles[0], roles[1], can_crit, guaranteed_hit);
	
	var roles0_hit_region = roles[0].attack_history[roles[0].attack_history.size() - 1].hit_region 
	
	
	if roles0_hit_region == GlobalsAutoload.location_types.IGNORE:
		if roles[0].current_block != GlobalsAutoload.location_types.NONE: 
			roles0_hit_region = GlobalsAutoload.convert_to_elavation(roles[0].current_block)	
			#if the attacks region is set to ignore it sets the var attack region to the current elvation
		else:
			roles0_hit_region = GlobalsAutoload.location_types.HIGH
			#if the fish is in the middle and the attack region is ignore it will default to its
			#attack location to high
	
	
	if roles[0] != roles[1]:
		if roles0_hit_region != roles[1].current_block: 
			roles[1].health -= damage_to_deal;
	else:
		roles[1].health -= damage_to_deal;
	
	GlobalsAutoload.shake_camera.emit(100 * damage_to_deal)
	GlobalsAutoload.health_updated.emit();
	
func _apply_combo_effects():
	BattleAutoload.apply_combo_effects(PlayerAutoload.current_combo)
	
