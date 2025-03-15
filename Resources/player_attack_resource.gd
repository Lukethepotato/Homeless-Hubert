extends Resource
class_name player_attack

# This is a flexible resource that stores the data for player attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var damage: float = 0
@export var animation_name: String = ""
@export var icon_texture: Texture2D
@export var hit_region := GlobalsAutoload.location_types.HIGH;
@export var gives_block := GlobalsAutoload.location_types.NONE;
