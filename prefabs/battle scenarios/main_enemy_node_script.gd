class_name Enemy
extends Node2D

# This node/script will store information and functions relating to an enemy/enemies.

# LISTEN UP MAGGOT! IF YOU WANT TO ADD TRAITS, FOLLOW THIS GUIDE!
# FIRST UP, GO TO globals_autoload AND ADD YOUR TRAIT TO THE traits ENUM!!
# AFTER THAT'S DONE, RETURN TO THIS SCRIPT AND MODIFY THE modify_stats_with_traits FUNCTION!
# YOU WANT TO ADD A NEW CASE TO THE SWITCH CASE STATEMENT FOR YOUR NEW TRAIT
# ONCE YOU'RE DONE WITH THAT, YOU'RE FINISHED!!!! GOOD JOB MAGGOT!

const type = "Enemy";
@export var fish_name := "Fuckin evil fred"; # Name of the fish
@export var name_color := Color.RED; # Color of the fish's name used for display

# Fish stats
@export var stat_dictionary = {
	"health" : 20, # Base health of player
	"max_health" : 20, # Maximum health of player
	"poise" : 100, # Percentage stance value; when poise hits 0, character is staggered
	"speed" : 10, # Player speed value
	"strength" : 1, # Additive factor to damage
	"defense" : 0, # Subtractive factor from damage taken
	"agility" : 1, # Additive factor to speed
	"luck" : 0, # Additive factor to critical chance (base chance = 1)
	"evasion" : 0, # Additive factor to dodge chance (base chance = 0)
	"disruption_resist" : 0.05, # Written as decimal, chance of resisting disruption
	"ailment_resist" : 0.05, # Written as decimal, chance of resisting ailment
}
@export var traits : Array[BattleAutoload.traits]; # Array containing all of the fish's traits

@export var attack_resources_in: Array[attack_parent]
@export var current_block := BattleAutoload.location_types.NONE
@export var attack_history: Array[attack_parent]
@export var block_inclination: float = 5
@export var goes_on_turn: int

@export var attacks_per_turn: int = 1 #the value must be typed here cuz _init magic bullshit #attack resources in size defaults to this

@export var attack_spots_parent :Control
@export var ailment_component_node: Node2D
@export var animation_player: AnimationPlayer #gets animation player (set here)
@export var enemy_attack_manager_node: Node2D #gets enemy_attack_manager (set here)

#number must be from 0 to 10, higher means more likly high block. The lower means more likly low block
func _init() -> void:
	BattleAutoload.enemy_node = self;
	attack_resources_in.resize(attacks_per_turn)

func _ready() -> void:
	enemy_attack_manager_node = $"Enemy attack manager"
	animation_player = %AnimPlayer
	attack_resources_in.resize(attacks_per_turn)
	ailment_component_node = %Ailments_parent
	stat_dictionary.speed += stat_dictionary.agility;
	modify_stats_with_traits();
	
func _process(delta: float) -> void:
	goes_on_turn = BattleAutoload.enemy_goes_on_turn


# Returns if a fish is able to combo
func is_fish_intelligent() -> bool:
	return traits.has(BattleAutoload.traits.INTELLIGENT);

# Modifies the fish stats based on what traits they have (INTELLIGENT NOT INCLUDED)
func modify_stats_with_traits() -> void:
	for fish_trait in traits:
		match fish_trait:
			BattleAutoload.traits.SLIPPERY:
				stat_dictionary.evasion += 20;
				if stat_dictionary.evasion >= 100:
					stat_dictionary.evasion = 99
				stat_dictionary.disruption_resist -= 0.20;
				if stat_dictionary.disruption_resist < 0:
					stat_dictionary.disruption_resist = 0;
			BattleAutoload.traits.OBESE:
				stat_dictionary.evasion -= 20;
				if stat_dictionary.evasion < 0:
					stat_dictionary.evasion = 0;
				stat_dictionary.disruption_resist += 0.20
			BattleAutoload.traits.FLEXIBLE:
				pass;
			BattleAutoload.traits.RIGID:
				pass;
			BattleAutoload.traits.VAMPIRE:
				# I don't know how you want to implement lifesteal so I'll leave it up to you unless you say otherwise
				stat_dictionary.strength += 1;
				stat_dictionary.defense -= 4;
			BattleAutoload.traits.FRENZIED:
				stat_dictionary.strength += 2;
				stat_dictionary.defense -= 2;
			BattleAutoload.traits.CALM:
				stat_dictionary.strength -= 2;
				stat_dictionary.defense += 2;
				stat_dictionary.disruption_resist += 0.05
			BattleAutoload.traits.FERAL:
				stat_dictionary.strength += 10
				stat_dictionary.defense -= 6;
				stat_dictionary.agility -= 2;
				stat_dictionary.evasion = 0;
				stat_dictionary.disruption_resist = 0;
			BattleAutoload.traits.DEADEYE:
				stat_dictionary.strength -= 4
				stat_dictionary.luck = 49;
			BattleAutoload.traits.HARDY:
				stat_dictionary.disruption_resist += 0.30;
				stat_dictionary.ailment_resist += 0.50;

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		GlobalsAutoload.info_popup_open.emit(self)
