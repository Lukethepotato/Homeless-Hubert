extends TextureRect

@export var dragTextureSize: Vector2 = Vector2(1,1)
@export var dragPreview: PackedScene
var orginText: Texture2D
static var dropped := false
@export var draggableUI: bool = true

@export var attack_resource: player_attack




#if your confused by all this your not dumb I am, dont even try to understand it just ask
#Luke he wrote this 
#Luke is a big dum dum


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func _get_drag_data(at_position):
	if dropped == false && draggableUI:
		orginText = texture
		var preview = dragPreview.instantiate()
		preview.connect("dragDrop", _reset)
		 
		preview.texture = texture
		preview.scale = dragTextureSize
		add_child(preview)
			
		#print("picked up " + name)
			
		var data = {}
		data["origin_Texture"] = texture
		data["orgin_Node"] = self
		data["orgin_Preview"] = preview
		data["attack_resource"] = attack_resource
		
		texture = null
		return data
	 
func _can_drop_data(_pos, data) -> bool:
	#print("the object drop data is call from is " + name)
	
	if texture == null:
		return true
	
	else:
		return false

 
func _drop_data(_pos, data):
	if draggableUI:
		texture = data["origin_Texture"]
		data["origin_Texture"] = null
		
		#theres an error here I cant bother to fix
		#its your problem now Jeremy
		
		#oh wait I fixed it nevermind, you owe me now
		
		
		if data["attack_resource"]!= null:
			GlobalsAutoload.emit_signal("dropped_UI", data["attack_resource"], get_parent().name)
		dropped = true
		print("dropped on " + name)
		
	
func _reset():
	if dropped == false:
		texture = orginText
	else:
		dropped = false
	
