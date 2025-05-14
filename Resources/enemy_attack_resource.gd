extends attack_parent
class_name enemy_attack

# This is a flexible resource that stores the data for enemy attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var preview_texture: Texture2D #this is the texture that is shown to show the enemeys next attack

@export var victim_speed_apply:= 0 #added to perps speed value on attack
