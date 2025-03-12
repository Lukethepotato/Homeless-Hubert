extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _damage_donation(amount: int):
	
	if GlobalsAutoload.current_turn == GlobalsAutoload.enemy_goes_on_turn:
		PlayerAutoload.health -= amount
		
	elif GlobalsAutoload.current_turn == PlayerAutoload.goes_on_turn:
		GlobalsAutoload.enemy_node.health -= amount
