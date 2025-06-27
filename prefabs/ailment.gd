extends Node2D

@export var current_ailment: ailment = null #if its null nothing happens
@export var turns_left: int
@export var target_data = null
@export var damage_donor_node: Node2D

@export var enemy_blocks: Array[attack_parent]
@export var animation_player: AnimationPlayer

var stat := "none";
var old_stat_value : int;
var modified_stat_value : int;


func _ready() -> void:
	BattleAutoload.current_turn_reset.connect(_turn_change)

func _turn_change():
	if turns_left <= 0:
		print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement end");
		if stat != "none":
			target_data.stat_dictionary[stat] = old_stat_value + (target_data.stat_dictionary[stat] - modified_stat_value)
		queue_free()
	elif current_ailment != null:
		_damage_take_per_turn()
		turns_left -= 1;

func _can_change_block() -> bool:
	if current_ailment != null:
		if current_ailment.lock_block == false:
			return false
	
	return true
	#for the enemy this is called on the block verdict componet and it makes sure they wont change block
	
func _damage_take_per_turn():
	if current_ailment.damage_take_per_turn > 0:
		damage_donor_node._damage_donation(get_parent().target, get_parent().target, current_ailment.damage_take_per_turn, false, true)
		print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailment damage");
		
			#if the lock block is set to none then they will simply just not be able to move
			

func _begin_ailment(ailment_chosen: ailment):
	target_data = BattleAutoload.convert_strs_to_attack_roles(get_parent().target, get_parent().target)
	target_data = target_data[0]
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement begin");
	current_ailment = ailment_chosen
	turns_left = ailment_chosen.turn_amount
	apply_stat_effects()
	if current_ailment.force_immediate_attack != null:
		BattleAutoload._manual_play_attack(get_parent().target, current_ailment.force_immediate_attack)

func apply_stat_effects():
	# ts so ugly vro 💔
	if current_ailment.stat_to_change != GlobalsAutoload.stats.NONE and current_ailment.modifier != GlobalsAutoload.modifiers.NONE:
		stat = get_stat_to_modify(current_ailment.stat_to_change);
		
		old_stat_value = target_data.stat_dictionary[stat];
		
		match current_ailment.modifier:
			GlobalsAutoload.modifiers.ADDITION:
				target_data.stat_dictionary[stat] = int(target_data.stat_dictionary[stat] + current_ailment.value)
			GlobalsAutoload.modifiers.SUBTRACTION:
				target_data.stat_dictionary[stat] = int(target_data.stat_dictionary[stat] - current_ailment.value)
			GlobalsAutoload.modifiers.MULTIPLICATION:
				target_data.stat_dictionary[stat] = int(target_data.stat_dictionary[stat] * current_ailment.value)
			GlobalsAutoload.modifiers.DIVISION:
				target_data.stat_dictionary[stat] = int(target_data.stat_dictionary[stat] / current_ailment.value);
		modified_stat_value = target_data.stat_dictionary[stat]
		print_rich("[color=goldenrod][font_size=20]Ailment changed target "+stat+" from " +str(old_stat_value)+ " to " +str(modified_stat_value));

func get_stat_to_modify(stat_enum : GlobalsAutoload.stats):
	match stat_enum:
		GlobalsAutoload.stats.HEALTH:
			return "health"
		GlobalsAutoload.stats.MAX_HEALTH:
			return "max_health"
		GlobalsAutoload.stats.SPEED:
			return "speed"
		GlobalsAutoload.stats.STRENGTH:
			return "strength"
		GlobalsAutoload.stats.DEFENSE:
			return "defense"
		GlobalsAutoload.stats.AGILITY:
			return "agility"
		GlobalsAutoload.stats.LUCK:
			return "luck"
		GlobalsAutoload.stats.EVASION:
			return "evasion"
		GlobalsAutoload.stats.DISRUPTION_RESIST:
			return "disruption_resist"
		GlobalsAutoload.stats.AILMENT_RESIST:
			return "ailment_resist"
	return "none"
