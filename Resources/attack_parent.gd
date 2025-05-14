extends Resource
class_name attack_parent

@export var base_damage := 0; # Base damage of the skill, unaffected by offensive and defensive modifiers
@export var priority := 0; # Additive priority value used in turn order calculation
@export var stance_disruption_mod := 1.0; # Multiplicative modifier for the amount of poise damage dealt by attack
@export var name := "Punch"; # Name for display
@export var name_color := Color.WHITE; # Name color used for display
@export var description := "Basic fist attack. Attack hits high, deals mediocre damage, and has little disruption."; # Description
@export var animation_name: String = ""; # Name of the animation to be played when the attack commences
@export var hit_region := GlobalsAutoload.location_types.HIGH; # Region wherein this attack will strike
@export var gives_block := GlobalsAutoload.location_types.NONE; # Type of block the attack will give after finishing

#these are values to be applied to the victim on attack
@export var victim_speed_subtract := 0
@export var victim_defense_subtract := 0
