extends Node2D

# This script is attached to the parent node of the main scene. It contains the battle scenarios whilst also handling battle commencement.

@export var battle_scenarios : Array[PackedScene]
	

func _on_fishing_spot_body_entered(body: Node2D) -> void:
	if body.name == "Hubert":
		GlobalsAutoload.start_battle(battle_scenarios);
		PlayerAutoload.position = $Hubert.position

func _Chromatic_func():
#(not exactly sure where to put this function if you wanna move it tell me)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(%chromatic_ab.material, "shader_parameter/chaos", 50, 0.5)
	tween.tween_interval(.1)
	tween.tween_property(%chromatic_ab.material, "shader_parameter/chaos", 0, 0.1)
	
#call this to make the screen chromatic aberation a bit
#give it a lil jiggle if you know what im saying homes'
