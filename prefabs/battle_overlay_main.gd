extends CanvasLayer

# This script is attached to the clickable UI of the battle scenario and handles checking both if the attack can be executed as well as clearing attack selection.
var tween;

func _ready() -> void:
	GlobalsAutoload.dropped_UI.connect(update_button)
	update_button();

func _on_attack_button_pressed() -> void:
	if is_attack_ready() && GlobalsAutoload.current_turn == 1:
		GlobalsAutoload.current_turn = 2
		print("current turn = 2 _ overlay")

func _on_clear_chosen_attacks_pressed() -> void:
	var tempSize:= PlayerAutoload.attack_resources_in.size()
	PlayerAutoload.attack_resources_in.clear()
	PlayerAutoload.attack_resources_in.resize(tempSize)
	
	for i in $attack_spots.get_child_count():
		$attack_spots.get_child(i).attack_resource_holding = null
		$attack_spots.get_child(i).get_child(1).texture = null
	
	call_deferred("update_button");

func is_attack_ready() -> bool:
	#for attack in PlayerAutoload.attack_resources_in:
		#if attack != null:
			#return true;
	#return false;
	return (PlayerAutoload.attack_resources_in[0] != null)

func update_button(_fuckts1 = null, _fuckts2 = null):
	print("update button")
	if tween:
		tween.kill();
	if is_attack_ready():
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"attack button", "position:y", 450, 0.5).from(800)
	else:
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO);
		tween.tween_property($"attack button", "position:y", 800, 0.5)
	$"attack button".disabled = not is_attack_ready();
