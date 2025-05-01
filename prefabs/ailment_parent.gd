extends Node2D
@export var ailment_component_prephab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _can_change_block() -> bool:
	if get_child(0) != null:
		for i in get_child_count():
			if get_child(i).current_ailment.lock_block != GlobalsAutoload.location_types.IGNORE:
				return false
	
	return true

func _instantiate_ailment(ailment_chosen: ailments):
	var new_ailment = ailment_component_prephab.instantiate()
	add_child(new_ailment)
	new_ailment._begin_ailment(ailment_chosen)
	new_ailment.damage_donar_node = %damage_donator #i give it the node this way because the intianted nodes cant call it
	
	print_rich("[color=cornflower_blue][shake amp=50.0 freq=5.0][wave amp=50.0 freq=5.0][font_size=50]new ailment instainated");
	
	#this instiantes the ailment componets that way we can have multiple ailments at the same time
