extends Node2D

# This script determines the order in which player attacks will be used. If the attack_slot_order variable is zero, the player attack in this slot will go first. If it is one, it will go second, and so on.

@export var attack_slot_order: int = 0
@export var slot_full: bool = false


func _ready() -> void:
	#GlobalsAutoload.dropped_UI.connect(dropped_in_spot_signal_receive)
	pass

# Do we really need to check this every frame?
func _process(delta: float) -> void:
	if get_parent().current_texture != null:
		slot_full = true
		PlayerAutoload.attack_resources_in[attack_slot_order] = get_parent().attack_resource_holding
		GlobalsAutoload.done_updating_attacks.emit()
	else:
		slot_full = false
		if PlayerAutoload.attack_resources_in[attack_slot_order] != null:
			PlayerAutoload.attack_resources_in[attack_slot_order] = null
	
#func dropped_in_spot_signal_receive(attack_resource: player_attack, dropped_where_name:String):
	#if (get_parent().name == dropped_where_name):
		#PlayerAutoload.attack_resources_in[attack_slot_order] = attack_resource
