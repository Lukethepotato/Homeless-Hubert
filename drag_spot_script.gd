extends TextureRect

# This script handles the icon dragging with draggable spots.

var original_texture: Texture2D
static var dropped := false
@export var drag_text_size: Vector2 = Vector2(1,1)
@export var drag_preview: PackedScene
@export var draggable_UI: bool = true
@export var attack_resource: player_attack

func _ready() -> void:
	GlobalsAutoload.clear_attack_selection.connect(_clear_attack_selection_receive)

func _process(delta: float) -> void:
	if attack_resource != null:
		texture = attack_resource.icon_texture

# This function gets and returns the data of this spot. It packages a texture, node, preview texture, and attack resource into a dictionary named "data".
func _get_drag_data(at_position):
	if dropped == false && draggable_UI:
		original_texture = texture
		var preview = drag_preview.instantiate()
		preview.connect("dragDrop", _reset)
		 
		preview.texture = texture
		preview.scale = drag_text_size
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
		print("dropped on " + name)

# This function resets the spot to its original texture.
func _reset():
	if dropped == false:
		texture = original_texture
	else:
		dropped = false

# This function removes the attack selection upon receiving the appropriate signal.
func _clear_attack_selection_receive():
	if texture != null && get_parent().attack_resource_give == null:
		attack_resource = null
		texture = null
