extends Node2D

# This script determines the order in which player attacks will be used. If the attack_slot_order variable is zero, the player attack in this slot will go first. If it is one, it will go second, and so on.

@export var attack_slot_order: int = 0
@export var slot_full: bool = false


func _ready() -> void:
	update_slot_order()
	BattleAutoload.current_turn_reset.connect(update_slot_order)
	
	#GlobalsAutoload.dropped_UI.connect(dropped_in_spot_signal_receive)

func update_slot_order():
	attack_slot_order = get_parent().get_index()

func _process(delta: float) -> void:
	update_slot_order()
	#attack_slot_order = get_parent().get_index()
	if get_parent().current_texture != null:
		slot_full = true
		PlayerAutoload.attack_resources_in[attack_slot_order] = get_parent().attack_resource_holding
		if attack_slot_order == PlayerAutoload.attack_resources_in.size()-1:
			BattleAutoload.done_updating_attacks.emit()
	else:
		slot_full = false
		if PlayerAutoload.attack_resources_in[attack_slot_order] != null:
			PlayerAutoload.attack_resources_in[attack_slot_order] = null
	
#func dropped_in_spot_signal_receive(attack_resource: attack_parent, dropped_where_name:String):
	#if (get_parent().name == dropped_where_name):
		#PlayerAutoload.attack_resources_in[attack_slot_order] = attack_resource
