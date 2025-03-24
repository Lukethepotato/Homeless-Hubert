extends Node

# This script contains miscellaneous data and functions pertaining to battles and battle calculations

enum traits {
	SLIPPERY,
	OBESE,
	FLEXIBLE,
	RIGID,
	VAMPIRE,
	FRENZIED,
	CALM,
	FERAL,
	DEADEYE,
	HARDY,
	INTELLIGENT
}
enum ailments {
	POISON,
	DAZE,
}

# Changes the PlayerAutoload goes_on_turn and the GlobalsAutoload enemy_goes_on_turn according to agility values and attack priority
func update_turn_order():
	PlayerAutoload.speed = get_player_speed();
	GlobalsAutoload.enemy_node.speed = get_enemy_speed();
	print("Player speed = " + str(PlayerAutoload.speed));
	print("Enemy speed = " + str(GlobalsAutoload.enemy_node.speed));
	if PlayerAutoload.speed > GlobalsAutoload.enemy_node.speed or (PlayerAutoload.speed == GlobalsAutoload.enemy_node.speed and randi_range(1,2) == 1):
		PlayerAutoload.goes_on_turn = 2;
		GlobalsAutoload.enemy_goes_on_turn = 3;
	else:
		PlayerAutoload.goes_on_turn = 3;
		GlobalsAutoload.enemy_goes_on_turn = 2;

# Returns what the player's speed would be for this turn
func get_player_speed() -> int:
	var speed = PlayerAutoload.speed;
	for attack in PlayerAutoload.attack_resources_in:
		if attack != null:
			speed += attack.priority;
	if speed < 0:
		speed = 0;
	return speed;

# Returns what the enemy's speed would be for this turn
func get_enemy_speed() -> int:
	var speed = GlobalsAutoload.enemy_node.speed;
	speed += GlobalsAutoload.enemy_node.get_child(1)._return_enemy_attack_choice().priority;
	if speed < 0:
		speed = 0;
	return speed;

# Returns a two-item array in the format of [User, Target]
func convert_strs_to_attack_roles(user : String, target : String) -> Array:
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
	
	return [perpetrator, victim]

# Calculates the damage that should be dealt. Extraneous parameters to be placed after the first three
func calculate_damage(base_dmg : int, user, target, can_crit := true, guaranteed_hit := false) -> int:
	var damage := base_dmg;
	#print("Base damage: " + str(damage))
	damage += user.strength;
	#print("Strength damage: " + str(damage))
	damage -= target.defense;
	#print("Defense damage: " + str(damage))
	if randi_range(1+user.luck, 100) >= 100 and can_crit:
		damage *= 2.5;
		print_rich("[color=gold][wave amp=50.0 freq=5.0][font_size=20]Critical: " + str(damage));
	if target.evasion > 0 and randi_range(target.evasion, 100) >= 100 and not guaranteed_hit:
		damage = 0;
		print_rich("[color=red][shake amp=50.0 freq=5.0][font_size=20]Evaded: " + str(damage));
	return damage;

# This function does the combo effects
func apply_combo_effects(combo : player_combo) -> void:
	print("Applying combo effects")
	var enemy = GlobalsAutoload.enemy_node
	PlayerAutoload.attack_history.clear()
	match combo.animation_name:
		"combo_slippy_trip":
			print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]Slippy Trip");
			enemy.traits.erase(traits.SLIPPERY);
			enemy.health -= 10;
			enemy.evasion -= 20;
			enemy.speed -= 2;
			if enemy.evasion < 0:
				enemy.evasion = 0;
	GlobalsAutoload.health_updated.emit();
