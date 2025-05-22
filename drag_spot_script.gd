extends TextureRect

# This script handles the icon dragging with draggable spots.

var original_texture: Texture2D
static var dropped := false
@export var drag_text_size: Vector2 = Vector2(1,1)
@export var drag_preview: PackedScene
@export var draggable_UI: bool = true
@export var attack_resource: attack_parent
var mouse_hovering := false;

func _ready() -> void:
	$"../attack_description".visible = false;

func _process(delta: float) -> void:
	if attack_resource != null:
		texture = attack_resource.icon_texture
	if Input.is_action_pressed("LMB"):
		mouse_hovering = false;
	if mouse_hovering:
		$"../attack_description".global_position = get_global_mouse_position() - Vector2(0, $"../attack_description".size.y);


# This function gets and returns the data of this spot. It packages a texture, node, preview texture, and attack resource into a dictionary named "data".
func _get_drag_data(at_position):
	if dropped == false && draggable_UI:
		original_texture = texture
		var preview = drag_preview.instantiate()
		preview.connect("dragDrop", _reset)
		 
		preview.texture = texture
		#preview.scale = drag_text_size
		add_child(preview)
		
		#print("picked up " + name)
		var data = {}
		data["original_texture"] = texture
		data["original_node"] = self
		data["original_preview"] = preview
		data["attack_resource"] = attack_resource
		
		texture = null
		return data

# This function returns whether or not this spot is available to have data dropped onto it.
func _can_drop_data(_pos, data) -> bool:
	#print("the object drop data is call from is " + name)
	if texture == null:
		return true
	else:
		return false

# This function receives a set of data and changes this node's variables accordingly. 
func _drop_data(_pos, data):
	if draggable_UI:
		texture = data["original_texture"]
		data["original_texture"] = null
		
		if data["attack_resource"] != null:
			get_parent().attack_resource_holding = data["attack_resource"]
			GlobalsAutoload.emit_signal("dropped_UI", data["attack_resource"], get_parent().name)
		dropped = true
		#print("dropped on " + name)

# This function resets the spot to its original texture.
func _reset():
	if dropped == false:
		texture = original_texture
	else:
		dropped = false

# Detects when the mouse enters the TextureRect and displays the associated information when proper
func _on_mouse_entered() -> void:
	#print("entered")
	mouse_hovering = true;
	GlobalsAutoload.timeout(1.0);
	await GlobalsAutoload.timer.timeout;
	if mouse_hovering and $"..".attack_resource_to_give != null:
		var text = "[font_size=40][color=" + str(attack_resource.name_color.to_html()) + "]" + attack_resource.name + "[/color][/font_size]"
		if attack_resource.base_damage > 0:
			text += "\n[font_size=25]  " + str(attack_resource.base_damage) + " base damage  [/font_size]";
		text += "\n[font_size=25]  " + str(attack_resource.priority) + " priority  [/font_size]"
		text += "\n[font_size=15]" + str(attack_resource.description) + "[/font_size]"
		$"../attack_description"/MarginContainer/description.text = text;
		$"../attack_description".visible = true;

# Detects when the mouse exits the TextureRect
func _on_mouse_exited() -> void:
	#print("exited")
	mouse_hovering = false;
	$"../attack_description".visible = false;
