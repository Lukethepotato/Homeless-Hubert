extends attack_parent
class_name player_attack

# This is a flexible resource that stores the data for player attacks. This is a loose template; further complexity can be added at the coder's discretion.

@export var enables_rush: bool = true #if this is the first attack it will rush if true and stay still if not
@export var icon_texture: Texture2D; # Name of the texture this attack will use
