extends Resource
class_name player_combo

# This is a flexible resource that stores the data for player combos. This is a loose template; further complexity can be added at the coder's discretion.

@export var attacks_in_combo : Array[attack_parent]
@export var animation_name := ""
@export var description := "";
@export var ailment_give : ailment = null
