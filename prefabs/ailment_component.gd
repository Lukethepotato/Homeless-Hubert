extends Node2D
@export var current_ailment: ailments = null #if its null nothing happens
@export var turns_left: int
@export var target: String #must be set to either "Player" or "Enemy"#turn in which everything happens
@export var target_data = null
@export var damage_donar_node: Node2D

@export var enemy_blocks: Array[enemy_attack]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.current_turn_reset.connect(_turn_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _damage_take_per_turn():
	damage_donar_node._damage_donation(target,target, current_ailment.damage_take_per_turn)
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailment damage");
	
func _turn_change():
	if turns_left <= 0:
		current_ailment = null
		print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement end");
		queue_free()
	
	if current_ailment != null:
		_damage_take_per_turn()
		_update_block_lock()
		turns_left -= 1;
		
		
func _can_change_block() -> bool:
	if current_ailment != null:
		if current_ailment.lock_block != GlobalsAutoload.location_types.IGNORE:
			return false
	
	return true
	#for the enemy this is called on the block verdict componet and it makes sure they wont change block
	
func _update_block_lock():
	if turns_left == current_ailment.turn_amount:
		if target == "Enemy":
			if target_data.current_block != current_ailment.lock_block:
				if current_ailment.lock_block == GlobalsAutoload.location_types.LOW:
					target_data.upcoming_attack = enemy_blocks[0]
				
				elif  current_ailment.lock_block == GlobalsAutoload.location_types.HIGH:
					target_data.upcoming_attack = enemy_blocks[1]
		
			#if the lock block is set to none then they will simply just not be able to move
		
	

func _begin_ailment(ailment_chosen: ailments):
	target_data = BattleAutoload.convert_strs_to_attack_roles(target,target)
	target_data = target_data[0]
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]ailement begin");
	current_ailment = ailment_chosen
	turns_left = ailment_chosen.turn_amount
