@tool

extends RichTextLabel

@export var max_width := 500;
 
func _ready():
	resized.connect(update_size)

# Updates the size of the popup box dynamically according to the textbox's size
func update_size():
	$"../..".size.x = size.x + $"..".get_theme_constant("margin_left") + $"..".get_theme_constant("margin_right");
	$"../..".size.y = size.y + $"..".get_theme_constant("margin_top") + $"..".get_theme_constant("margin_bottom"); 
	if autowrap_mode == TextServer.AUTOWRAP_OFF:
		check_width();

# Checks the size of the popup box for being larger than the set max_width variable
func check_width():
	if (size.x >= max_width):
		autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		custom_minimum_size.x = max_width
