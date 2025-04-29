extends Node2D
@export var current_ailment: ailments = null
@export var turns_left: int
@export var target: String #must be set to either "Player" or "Enemy"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.turn_changed.connect(_damage_take_per_turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _damage_take_per_turn():
	%damage_donator._damage_donation(target,target, current_ailment.damage_take_per_turn)
	
func _begin_ailment(ailment_chosen: ailments):
	current_ailment = ailment_chosen
	turns_left = ailment_chosen.turn_amount
