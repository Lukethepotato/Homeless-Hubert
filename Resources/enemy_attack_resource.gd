extends Resource
class_name enemy_attack

# This is a flexible resource that stores the data for enemy attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var damage: int
@export var animation_name: String

@export var hit_region := GlobalsAutoload.location_types.HIGH;
@export var gives_block := GlobalsAutoload.location_types.NONE;

#this is supposed to be flexible script that stores the data for attacks
#since there resources this is just the template and we add more varibles if need be
