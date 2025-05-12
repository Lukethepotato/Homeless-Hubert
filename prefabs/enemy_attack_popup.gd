extends Control

# This script contains the enemy attack description popup logic

var mouse_hovering;

func _ready() -> void:
	$TextureRect/attack_description.visible = false;
	

func _process(delta: float) -> void:
	if mouse_hovering:
		$TextureRect/attack_description.global_position = get_global_mouse_position() - Vector2($TextureRect/attack_description.size.x, $TextureRect/attack_description.size.y) + Vector2(40,22.5);

# Detects when the mouse enters the TextureRect and displays the associated information when proper
func _on_mouse_entered() -> void:
	#print("entered")
	mouse_hovering = true;
	GlobalsAutoload.timeout(1.0);
	await GlobalsAutoload.timer.timeout;
	if mouse_hovering and GlobalsAutoload.current_turn == 1:
		var text = "[font_size=40][color=" + str(GlobalsAutoload.enemy_node.upcoming_attack.name_color.to_html()) + "]" + GlobalsAutoload.enemy_node.upcoming_attack.name + "[/color][/font_size]"
		if GlobalsAutoload.enemy_node.upcoming_attack.base_damage > 0:
			text += "\n[font_size=25]  " + str(GlobalsAutoload.enemy_node.upcoming_attack.base_damage) + " base damage  [/font_size]";
		text += "\n[font_size=25]  " + str(GlobalsAutoload.enemy_node.upcoming_attack.priority) + " priority  [/font_size]"
		text += "\n[font_size=15]" + str(GlobalsAutoload.enemy_node.upcoming_attack.description) + "[/font_size]"
		$TextureRect/attack_description/MarginContainer/description.text = text;
		$TextureRect/attack_description.visible = true;

# Detects when the mouse exits the TextureRect
func _on_mouse_exited() -> void:
	#print("exited")
	mouse_hovering = false;
	$TextureRect/attack_description.visible = false;
