extends Node2D
@export var ailment_component_prefab: PackedScene
@export var target: String # must be set to either "Player" or "Enemy" (if in enemy scene use "Enemy" and vise versa)
@export var target_data = null
@export var current_ailment_anim: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_data = BattleAutoload.convert_strs_to_attack_roles(target, target)
	target_data = target_data[0]
	
	target_data.ailment_component_node = self
		# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _animtion_decision() -> String:
	var current_ailment_winner: Node2D = null
	for i in get_child_count():
		
		var ailment_competitor: Node2D = get_child(i)
		if ailment_competitor != null:
			if ailment_competitor.current_ailment.animation_name != "":
				if current_ailment_winner == null || (ailment_competitor.current_ailment.animation_priority >= current_ailment_winner.current_ailment.animation_priority):
					current_ailment_winner = ailment_competitor
		
	if current_ailment_winner != null:
		return current_ailment_winner.current_ailment.animation_name
		
	else:
		return ""



	#if GlobalsAutoload.current_turn == target_data.goes_on_turn:
			#if (ailment_competitor.current_ailment.animation_priority >= current_ailment_anim.current_ailment.animation_priority) || current_ailment_anim == null:
				#%AnimPlayer.play(ailment_competitor.current_ailment.animation_name)
				#ailment_competitor = current_ailment_anim

func _can_change_block() -> bool:
	if get_child(0) != null:
		for i in get_child_count():
			if get_child(i).current_ailment.lock_block != GlobalsAutoload.location_types.IGNORE:
				return false
	return true

	

func _instantiate_ailment(ailment_chosen: ailment):
	var new_ailment = ailment_component_prefab.instantiate()
	add_child(new_ailment)
	new_ailment._begin_ailment(ailment_chosen)
	new_ailment.damage_donor_node = %damage_donator #i give it the node this way because the intianted nodes cant call it
	new_ailment.animation_player = %AnimPlayer
	
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]new ailment instainated");
	
	#this instiantes the ailment componets that way we can have multiple ailments at the same time
