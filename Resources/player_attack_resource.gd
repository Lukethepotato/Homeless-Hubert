extends attack_parent
class_name player_attack

# This is a flexible resource that stores the data for player attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var base_damage := 0; # Base damage of the skill, unaffected by offensive and defensive modifiers
@export var priority := 0; # Additive priority value used in turn order calculation
@export var stance_disruption_mod := 1.0; # Multiplicative modifier for the amount of poise damage dealt by attack
@export var name := "Punch"; # Name for display
@export var name_color := Color.WHITE; # Name color used for display
@export var description := "Basic fist attack. Attack hits high, deals mediocre damage, and has little disruption."; # Description
@export var animation_name: String = ""; # Name of the animation to be played when the attack commences
@export var icon_texture: Texture2D; # Name of the texture this attack will use
@export var hit_region := GlobalsAutoload.location_types.HIGH; # Region wherein this attack will strike
@export var gives_block := GlobalsAutoload.location_types.NONE; # Type of block the attack will give after finishing
@export var enables_rush: bool = true #if this is the first attack it will rush if true and stay still if not

#these are values to be applied to the victim on attack
@export var victim_speed_subtract := 0;
@export var victim_defense_subtract := 0;
