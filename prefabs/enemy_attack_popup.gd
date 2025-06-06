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
	if mouse_hovering and BattleAutoload.current_turn_state == BattleAutoload.battle_states.SELECTION:
		var text = "[font_size=40][color=" + str(BattleAutoload.enemy_node.attack_resources_in[get_parent().get_index()].name_color.to_html()) + "]" + BattleAutoload.enemy_node.upcoming_attack.name + "[/color][/font_size]"
		if BattleAutoload.enemy_node.attack_resources_in[get_parent().get_index()].attack_resources_in[get_parent().get_index()].base_damage > 0:
			text += "\n[font_size=25]  " + str(BattleAutoload.enemy_node.attack_resources_in[get_parent().get_index()].base_damage) + " base damage  [/font_size]";
		text += "\n[font_size=25]  " + str(BattleAutoload.enemy_node.attack_resources_in[get_parent().get_index()].priority) + " priority  [/font_size]"
		text += "\n[font_size=15]" + str(BattleAutoload.enemy_node.attack_resources_in[get_parent().get_index()].description) + "[/font_size]"
		$TextureRect/attack_description/MarginContainer/description.text = text;
		$TextureRect/attack_description.visible = true;

# Detects when the mouse exits the TextureRect
func _on_mouse_exited() -> void:
	#print("exited")
	mouse_hovering = false;
	$TextureRect/attack_description.visible = false;
