extends Control

@export var attack_spot_node: PackedScene
@export var user: String
@export var orgin_pos: Vector2
@export var pos_offset: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_setting_attack_spots()
	GlobalsAutoload.current_turn_reset.connect(call_setting_attack_spots); # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func call_setting_attack_spots():
	print("attack spots called from " + get_name())
	BattleAutoload.setting_attack_spots(attack_spot_node, self, user, orgin_pos, pos_offset)
