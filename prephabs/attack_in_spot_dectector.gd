extends Node2D
@export var order_slot_attack: int = 0
#this is like the order that whatever attack put will go
#so if its zero the attack put in this slot will go first
#if its 1 the attack will go second
@export var slot_full: bool = false



func _ready() -> void:
	#GlobalsAutoload.dropped_UI.connect(dropped_in_spot_signal_receive) # Replace with function body.
	pass

func _process(delta: float) -> void:
	if get_parent().currentTexture != null:
		slot_full = true
		PlayerAutoload.attack_resources_in[order_slot_attack] = get_parent().attack_resource_holding
	else:
		slot_full = false
		
		if PlayerAutoload.attack_resources_in[order_slot_attack] != null:
			PlayerAutoload.attack_resources_in[order_slot_attack] = null
	
#func dropped_in_spot_signal_receive(attack_resource: player_attack, dropped_where_name:String):
	#if (get_parent().name == dropped_where_name):
		#PlayerAutoload.attack_resources_in[order_slot_attack] = attack_resource
	 # Replace with function body.
