extends CanvasLayer

@export var attack_spot_node: PackedScene
@export var user: String

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	call_setting_attack_spots()
	GlobalsAutoload.turn_changed.connect(call_setting_attack_spots); # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func call_setting_attack_spots():
	BattleAutoload.setting_attack_spots(attack_spot_node, self, user)
