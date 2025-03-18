extends Node2D

# This node/script will store information and functions relating to an enemy/enemies.

# Fish stats
@export var health: int = 20 # Base health of fish
@export var traits : Array[int]; # Array containing all of the fish's traits
@export var strength := 1; # Additive factor to damage
@export var defense := 0; # Subtractive factor from damage taken
@export var agility := 1; # Additive factor to speed
@export var luck := 0; # Additive factor to critical chance
@export var evasion := 0.05; # Written as decimal, chance of dodging out of 1
@export var disruption_resist := 0.05; # Written as decimal, chance of resisting disruption


@export var current_block := GlobalsAutoload.location_types.NONE
@export var attack_history: Array[enemy_attack]

func _ready() -> void:
	GlobalsAutoload.enemy_node = self;
	modify_stats_with_traits();

# Returns if a fish is able to combo
func is_fish_intelligent() -> bool:
	return traits.has(GlobalsAutoload.traits.INTELLIGENT);

# Modifies the fish stats based on what traits they have (INTELLIGENT NOT INCLUDED)
func modify_stats_with_traits() -> void:
	for fish_trait in traits:
		match fish_trait:
			GlobalsAutoload.traits.SLIPPERY:
				evasion += 0.20;
				disruption_resist -= 0.20;
				if disruption_resist < 0:
					disruption_resist = 0;
			GlobalsAutoload.traits.OBESE:
				evasion -= 0.20;
				if evasion < 0:
					evasion = 0;
				disruption_resist += 0.20
			GlobalsAutoload.traits.FLEXIBLE:
				pass;
			GlobalsAutoload.traits.RIGID:
				pass;
