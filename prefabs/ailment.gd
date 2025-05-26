extends Node2D

@export var current_ailment: ailment = null #if its null nothing happens
@export var turns_left: int
@export var target_data = null
@export var damage_donor_node: Node2D

@export var enemy_blocks: Array[attack_parent]
@export var animation_player: AnimationPlayer

var old_stat_value;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BattleAutoload.current_turn_reset.connect(_turn_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _turn_change():
	if turns_left <= 0:
		print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement end");
		var stat;
		stat = old_stat_value;
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
		damage_donor_node._damage_donation(get_parent().target, get_parent().target, current_ailment.damage_take_per_turn)
		print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailment damage");
		
			#if the lock block is set to none then they will simply just not be able to move
			

func _begin_ailment(ailment_chosen: ailment):
	target_data = BattleAutoload.convert_strs_to_attack_roles(get_parent().target, get_parent().target)
	target_data = target_data[0]
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement begin");
	current_ailment = ailment_chosen
	turns_left = ailment_chosen.turn_amount
	if current_ailment.force_immediate_attack != null:
		BattleAutoload._manual_play_attack(get_parent().target, current_ailment.force_immediate_attack)

func apply_stat_effects():
	# ts so ugly vro 💔
	if current_ailment.stat_to_change != GlobalsAutoload.stats.NONE and current_ailment.modifier != GlobalsAutoload.modifiers.NONE:
		var stat;
		
		old_stat_value = stat;
		
		match current_ailment.modifier:
			GlobalsAutoload.modifiers.ADDITION:
				stat += current_ailment.value;
			GlobalsAutoload.modifiers.SUBTRACTION:
				stat -= current_ailment.value;
			GlobalsAutoload.modifiers.MULTIPLICATION:
				stat *= current_ailment.value;
			GlobalsAutoload.modifiers.DIVISION:
				stat /= current_ailment.value;
