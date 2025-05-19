class_name Player_Details
extends Node

# This is a global script which contains most of the details about the Player character. If needed, it will also contain functions that need to be universally accessible.

@export var attack_resources_in: Array[attack_parent]
@export var goes_on_turn: int = 2
@export var attack_history: Array[attack_parent]
@export var current_combo: player_combo
#this is set when the combo combo is played in the main dock animation player

@export var player_name := "Hubert"; # Name of the player
@export var name_color := Color.WHITE; # Color of the player's name used for display
@export var position := Vector2(0,0); # Position of player for damage popup numbers

# Player stats
@export var health := 15 # Base health of player
@export var max_health := 15 # Maximum health of player
@export var poise := 100 # Percentage stance value; when poise hits 0, character is staggered
@export var speed := 10; # Player speed value
@export var strength := 1; # Additive factor to damage
@export var defense := 0; # Subtractive factor from damage taken
@export var agility := 1; # Additive factor to speed
@export var luck := 99; # Additive factor to critical chance (base chance = 1)
@export var evasion := 1; # Additive factor to dodge chance (base chance = 0)

# Resistances
@export var disruption_resist := 0.05; # Written as decimal, chance of resisting disruption
@export var ailment_resist := 0.05; # Written as decimal, chance of resisting ailment

@export var current_block := GlobalsAutoload.location_types.NONE
#the idea is that every attack you do will determine a block state that hubert will do
#and the curent state huberts in is just stored here
@export var attack_spots_parent :Control
@export var ailment_component_node: Node2D
@export var attacks_per_turn: int = 2 #this is not a value to change its just the value that the attack resources in size defaults to


#use this to change one of the players attacks chosen in code
func manually_change_player_attack(attack_change: attack_parent, allow_drag: bool, attack_index: int, allow_reset: bool):
	GlobalsAutoload.timeout(.1);
	await GlobalsAutoload.timer.timeout;
	#the timer to make sure it happens after the spots are reset
	
	var attack_spot_node: Control = PlayerAutoload.attack_spots_parent.get_child(attack_index)
	
	attack_spot_node.current_texture = attack_change.icon_texture
	attack_spot_node.attack_resource_holding = attack_change
	attack_spot_node.reset_allowed = allow_reset
	#this gets the texture rect
	attack_spot_node.get_child(2).texture = attack_change.icon_texture
	attack_spot_node.get_child(2).attack_resource = attack_change
	attack_spot_node.get_child(2).draggable_UI = allow_drag
	
	print("change attack in spot to " + attack_change.animation_name)


#func _ready() -> void:
	#attack_resources_in.resize(4)
