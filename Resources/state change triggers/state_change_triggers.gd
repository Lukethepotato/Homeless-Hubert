extends Resource
class_name state_change_trigger

@export var stat_diffrence:= 10
#@export var enemy_stat:= GlobalsAutoload.stats.NONE
#@export var player_stat:= GlobalsAutoload.stats.NONE
@export var enemy_stat:String
@export var player_stat:String

#these a the parameters for the state change trigger to occur
#example: enemey stat is defense and player stat is strength
#the enemy defense is 40 and the player strength is 50 and the stat diffrence is set to 10
#the state change would trigger

@export var state_change_to: String 
#this changes the sate node with the same name as this string

func trigger_check() -> bool:
	if (PlayerAutoload.stat_dictionary[player_stat] - BattleAutoload.enemy_node.stat_dictionary[enemy_stat]) >= stat_diffrence:
		return true
	else:
		return false 
	
