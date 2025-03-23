extends Resource
class_name enemy_attack

# This is a flexible resource that stores the data for enemy attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var base_damage := 0; # Base damage of the skill, unaffected by offensive and defensive modifiers
@export var priority := 0; # Additive priority value used in turn order calculation
@export var animation_name: String = ""; # Name of the animation to be played when the attack commences
@export var hit_region := GlobalsAutoload.location_types.HIGH; # Region wherein this attack will strike
@export var gives_block := GlobalsAutoload.location_types.NONE; # Type of block the attack will give after finishing
