extends Control
@export var setTextureTo: Texture2D
@export var currentTexture: Texture2D
@export var attack_resource_give: player_attack
#if this a UI peice that shows one of the attacks you can drag
#this var determines what attack that would be

func _ready() -> void:
	%TextureRect.texture = setTextureTo
	%TextureRect.attack_resource = attack_resource_give
	#if your worried that the texture is not being set to the attack icon dont
	#even fret if you check in the draggable spot node its automatily set to 
	#the resources texture in process
	
func _process(delta: float) -> void:
	currentTexture = %TextureRect.texture
