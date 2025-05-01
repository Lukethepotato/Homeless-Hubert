extends Resource
class_name ailments

@export var turn_amount: int = 2
@export var lock_block: GlobalsAutoload.location_types #if ignore then not locked
@export var lock_attack: bool
@export var damage_take_per_turn: int
@export var animation_name: String #if not set to anything the characters animation wont change
@export var ailment_icon: Texture2D

#wanna have somthing like an overlay or someway to change the shader
#but dont know how to make
