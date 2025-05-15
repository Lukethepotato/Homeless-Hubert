extends Node2D
@export var current_ailment: ailment = null #if its null nothing happens
@export var turns_left: int
@export var target_data = null
@export var damage_donor_node: Node2D

@export var enemy_blocks: Array[attack_parent]
@export var animation_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.current_turn_reset.connect(_turn_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _turn_change():
	if turns_left <= 0:
		print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement end");
		queue_free()
	elif current_ailment != null:
		_damage_take_per_turn()
		_update_block_lock()
		turns_left -= 1;
		
		
func _can_change_block() -> bool:
	if current_ailment != null:
		if current_ailment.lock_block != GlobalsAutoload.location_types.IGNORE:
			return false
	
	return true
	#for the enemy this is called on the block verdict componet and it makes sure they wont change block
	
func _damage_take_per_turn():
	if current_ailment.damage_take_per_turn > 0:
		damage_donor_node._damage_donation(get_parent().target,get_parent().target, current_ailment.damage_take_per_turn)
		print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailment damage");
	
func _update_block_lock():
	if turns_left == current_ailment.turn_amount:
		if get_parent().target == "Enemy":
			if target_data.current_block != current_ailment.lock_block:
				if current_ailment.lock_block == GlobalsAutoload.location_types.LOW:
					target_data.attack_resources_in[0] = enemy_blocks[0]
				
				elif  current_ailment.lock_block == GlobalsAutoload.location_types.HIGH:
					target_data.attack_resources_in[0] = enemy_blocks[1]
		
			#if the lock block is set to none then they will simply just not be able to move
			

func _begin_ailment(ailment_chosen: ailment):
	target_data = BattleAutoload.convert_strs_to_attack_roles(get_parent().target,get_parent().target)
	target_data = target_data[0]
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement begin");
	current_ailment = ailment_chosen
	turns_left = ailment_chosen.turn_amount
