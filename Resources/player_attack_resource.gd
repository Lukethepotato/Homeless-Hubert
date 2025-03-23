extends Resource
class_name player_attack

# This is a flexible resource that stores the data for player attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var base_damage := 0; # Base damage of the skill, unaffected by offensive and defensive modifiers
@export var priority := 0; # Additive priority value used in turn order calculation
@export var name := "Punch"; # Name
@export var name_color := Color.WHITE; # Name color
@export var description := "Basic fist attack. Attack hits high, deals mediocre damage, and has little disruption."; # Description
@export var animation_name: String = ""; # Name of the animation to be played when the attack commences
@export var icon_texture: Texture2D; # Name of the texture this attack will use
@export var hit_region := GlobalsAutoload.location_types.HIGH; # Region wherein this attack will strike
@export var gives_block := GlobalsAutoload.location_types.NONE; # Type of block the attack will give after finishing
