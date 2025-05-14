extends attack_parent
class_name enemy_attack

# This is a flexible resource that stores the data for enemy attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var base_damage := 0; # Base damage of the skill, unaffected by offensive and defensive modifiers
@export var priority := 0; # Additive priority value used in turn order calculation
@export var stance_disruption_mod := 1.0; # Multiplicative modifier for the amount of poise damage dealt by attack
@export var name := "Punch"; # Name for display
@export var name_color := Color.WHITE; # Name color used for display
@export var description := "Basic attack. Attack hits high and deals 10 damage."; # Description
@export var animation_name: String = ""; # Name of the animation to be played when the attack commences
@export var hit_region := GlobalsAutoload.location_types.HIGH; # Region wherein this attack will strike
@export var gives_block := GlobalsAutoload.location_types.NONE; # Type of block the attack will give after finishing
@export var preview_texture: Texture2D #this is the texture that is shown to show the enemeys next attack

#@export var ailment_give: ailment # Ailment to be applied on attack
@export var victim_speed_subtract := 0
@export var victim_defense_subtract := 0
@export var victim_speed_apply:= 0 #added to perps speed value on attack
