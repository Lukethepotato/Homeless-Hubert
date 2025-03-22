class_name Player_Details
extends Node

# This is a global script which contains most of the details about the Player character. If needed, it will also contain functions that need to be universally accessible.

@export var attack_resources_in: Array[player_attack]
@export var goes_on_turn: int = 2
@export var attack_history: Array[player_attack]

@export var player_name := "Hubert";

# Player stats
@export var health := 15 # Base health of player
@export var max_health := 15 # Maximum health of player
@export var strength := 1; # Additive factor to damage
@export var defense := 0; # Subtractive factor from damage taken
@export var agility := 1; # Additive factor to speed
@export var luck := 0; # Additive factor to critical chance (base chance = 1)
@export var evasion := 1; # Additive factor to dodge chance (base chance = 0)

# Resistances
@export var disruption_resist := 0.05; # Written as decimal, chance of resisting disruption
@export var ailment_resist := 0.05; # Written as decimal, chance of resisting ailment

@export var current_block := GlobalsAutoload.location_types.NONE
#the idea is that every attack you do will determine a block state that hubert will do
#and the curent state huberts in is just stored here


func _ready() -> void:
	attack_resources_in.resize(2)
