extends Control

# This script contains various variables regarding drag nodes as well as updating textures and resources at various points during runtime.

@export var texture_to_set: Texture2D
@export var current_texture: Texture2D
#this var should be received not changed
#if you want to change the texture use the texture rect child
@export var attack_resource_to_give: player_attack
#this var should be received not changed
@export var attack_resource_holding: player_attack

func _ready() -> void:
	%TextureRect.texture = texture_to_set
	%TextureRect.attack_resource = attack_resource_to_give
	GlobalsAutoload.dropped_UI.connect(_spot_dropped)
	
	#if your worried that the texture is not being set to the attack icon dont
	#even fret if you check in the draggable spot node its automatily set to 
	#the resources texture in process
	# ???

func _spot_dropped(attack_resource: player_attack, dropped_where_name: String):
	current_texture = %TextureRect.texture
