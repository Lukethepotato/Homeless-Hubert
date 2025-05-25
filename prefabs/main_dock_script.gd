extends Node2D

# This script is attached to the parent node of the main scene. It contains the battle scenarios whilst also handling battle commencement.

@export var battle_scenarios : Array[PackedScene]

func _ready() -> void:
	GlobalsAutoload.game_over.connect(kill_hubert)
	GlobalsAutoload.camera = %main_camera
	GlobalsAutoload.end_load.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ESCAPE") and GlobalsAutoload.state == GlobalsAutoload.game_states.ROAMING:
		GlobalsAutoload.pause()

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

func _on_death_zone_body_entered(body: Node2D) -> void:
	print("haha")
	GlobalsAutoload.trigger_game_over();

func kill_hubert():
	$dock.visible = false;
	$Hubert/Hubert_Sprites.play("dead")
	GlobalsAutoload.timeout(0.5, false);
	await GlobalsAutoload.timer.timeout;
	$Hubert/main_camera.end_battle_camera(1)
