extends State
class_name agresive

func enter():
	%"Enemy attack manager".fallback_attack = set_fallback_attack
	
	for i in %"Enemy attack manager".get_children():
		i.set_process(true)
	#first turns on all attack managers
	
	for i in attack_deciders_to_disable.size():
		get_node(attack_deciders_to_disable[i]).set_process(false)
	#then disables the desired ones 
	
	%"Attack pattern".attack_pattern = attack_pattern_set
	
