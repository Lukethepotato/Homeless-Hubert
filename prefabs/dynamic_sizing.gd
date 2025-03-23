@tool

extends RichTextLabel

@export var max_width := 500;
 
func _ready():
	# connect the 'resized' signal to the 'check_width()' function
	resized.connect(update_size)

func update_size():
	$"../..".size.x = size.x;
	$"../..".size.y = size.y; 
	if autowrap_mode == TextServer.AUTOWRAP_OFF:
		check_width();

func check_width():
	if (size.x >= max_width):
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		custom_minimum_size.x = max_width
