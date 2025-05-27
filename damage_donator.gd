extends Node2D
@export var camera_shake_mult: float

# This script contains a single "damage donation" function which takes in an integer as the damage dealt in a given attack. The function itself checks which character should receive the damage.

# User is who is using the attack, Target is the target of the attack, Base_dmg is the attack base damage, Can_crit is if the attack can crit, 
# Guaranteed_hit is if the attack can miss

func _damage_donation(user : String, target : String, base_dmg: int, combo : player_combo = null, can_crit := true, guaranteed_hit := false):
	var roles = BattleAutoload.convert_strs_to_attack_roles(user, target)
	var damage_to_deal = 0
	var user_attack_region = roles[0].attack_history[roles[0].attack_history.size() - 1].hit_region 
	
	if user_attack_region == BattleAutoload.location_types.IGNORE:
		if roles[0].current_block != BattleAutoload.location_types.NONE: 
			user_attack_region = BattleAutoload.convert_to_elevation(roles[0].current_block)	
			#if the attacks region is set to ignore it sets the var attack region to the current elvation
		else:
			user_attack_region = BattleAutoload.location_types.HIGH
			#if the fish is in the middle and the attack region is ignore it will default to its
			#attack location to high
	
	if roles[0] != roles[1]:
		if user_attack_region != roles[1].current_block: 
			var last_attack_done = roles[0].attack_history[roles[0].attack_history.size() -1]
			damage_to_deal = BattleAutoload.calculate_damage(base_dmg, roles[0], roles[1], can_crit, guaranteed_hit);
			
			roles[1].stat_dictionary.health -= damage_to_deal;
			roles[1].stat_dictionary.poise -= damage_to_deal * last_attack_done.stance_disruption_mod
			print("Poise : " + str(roles[1].stat_dictionary.poise))
			if roles[1].stat_dictionary.poise <= 0:
				pass
				#roles[1].ailment_component_node._instantiate_ailment(load("res://Resources/ailments/staggered.tres"))
				# reset poise back somehow (:
			BattleAutoload.apply_attack_effects(last_attack_done, user, target)
			
			GlobalsAutoload.shake_camera.emit(camera_shake_mult * damage_to_deal)
	else:
		damage_to_deal = BattleAutoload.calculate_damage(base_dmg, roles[0], roles[1], can_crit, guaranteed_hit);
		
		roles[1].stat_dictionary.health -= damage_to_deal;
		GlobalsAutoload.shake_camera.emit(camera_shake_mult * damage_to_deal)
	
	BattleAutoload.health_updated.emit();
	
	if PlayerAutoload.stat_dictionary.health <= 0 and GlobalsAutoload.mortality:
		GlobalsAutoload.trigger_game_over();


func _apply_combo_effects():
	print("apply combo effects " + PlayerAutoload.current_combo.animation_name)
	BattleAutoload.apply_combo_effects(PlayerAutoload.current_combo)
