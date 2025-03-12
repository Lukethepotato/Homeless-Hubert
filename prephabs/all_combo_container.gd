extends Node2D
@export var combo_resources: Array[player_combo]
#wanna add combo? (:
#you need to first make the resource and define the attacks needed in the array in order
#then add that resource to this combo resource array
#this creates a sort of array in array thing
#it really an array of resources that each contain an array of the attacks



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalsAutoload.combo_node = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
