extends Node2D

# This node/script will store information and functions relating to an enemy/enemies.

# LISTEN UP MAGGOT! IF YOU WANT TO ADD TRAITS, FOLLOW THIS GUIDE!
# FIRST UP, GO TO globals_autoload AND ADD YOUR TRAIT TO THE traits ENUM!!
# AFTER THAT'S DONE, RETURN TO THIS SCRIPT AND MODIFY THE modify_stats_with_traits FUNCTION!
# YOU WANT TO ADD A NEW CASE TO THE SWITCH CASE STATEMENT FOR YOUR NEW TRAIT
# ONCE YOU'RE DONE WITH THAT, YOU'RE FINISHED!!!! GOOD JOB MAGGOT!

# Fish stats
@export var health: int = 20 # Base health of fish
@export var traits : Array[int]; # Array containing all of the fish's traits
@export var strength := 1; # Additive factor to damage
@export var defense := 0; # Subtractive factor from damage taken
@export var agility := 1; # Additive factor to speed
@export var luck := 0; # Additive factor to critical chance (base chance = 1)
@export var evasion := 0.05; # Written as decimal, chance of dodging out of 1

# Resistances
@export var disruption_resist := 0.05; # Written as decimal, chance of resisting disruption
@export var ailment_resist := 0.05; # Written as decimal, chance of resisting ailment


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
			GlobalsAutoload.traits.VAMPIRE:
				# I don't know how you want to implement lifesteal so I'll leave it up to you unless you say otherwise
				strength += 1;
				defense -= 4;
			GlobalsAutoload.traits.FRENZIED:
				strength += 2;
				defense -= 2;
			GlobalsAutoload.traits.CALM:
				strength -= 2;
				defense += 2;
				disruption_resist += 0.05
			GlobalsAutoload.traits.FERAL:
				strength += 10
				defense -= 6;
				agility -= 2;
				evasion = 0;
				disruption_resist = 0;
			GlobalsAutoload.traits.DEADEYE:
				strength -= 4
				luck = 49;
			GlobalsAutoload.traits.HARDY:
				disruption_resist += 0.30;
				ailment_resist += 0.50;
