extends State
class_name Defensive

func enter():
	%"Enemy attack manager".fallback_attack = set_fallback_attack
	
	for i in %"Enemy attack manager".get_children():
		i.disabled = false
	#first turns on all attack managers
	
	for i in attack_deciders_to_disable.size():
		get_node(attack_deciders_to_disable[i]).disabled = true
	#then disables the desired ones 
	
	%"Attack pattern".attack_pattern = attack_pattern_set
	
