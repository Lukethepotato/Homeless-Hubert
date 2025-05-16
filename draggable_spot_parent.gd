extends Control

# This script contains various variables regarding drag nodes as well as updating textures and resources at various points during runtime.

@export var texture_to_set: Texture2D
@export var current_texture: Texture2D
#this var should be received not changed
#if you want to change the texture use the texture rect child
@export var attack_resource_to_give: attack_parent
#this var should be received not changed
@export var attack_resource_holding: attack_parent

var tween;

func _ready() -> void:
	%TextureRect.texture = texture_to_set
	%TextureRect.attack_resource = attack_resource_to_give
	GlobalsAutoload.dropped_UI.connect(_spot_dropped)
	
	#if your worried that the texture is not being set to the attack icon dont
	#even fret if you check in the draggable spot node its automatily set to 
	#the resources texture in process
	# ???

# This function resets the displayed data of the draggable spot
func reset():
	attack_resource_holding = null
	if tween:
		tween.kill();
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE).set_parallel(true);
	tween.tween_property(%TextureRect, "scale", Vector2(0.05,0.05), 0.5).from(Vector2(1,1))
	tween.tween_property(%TextureRect, "rotation_degrees", 360, 0.5).from(0);
	await tween.finished;
	%TextureRect.texture = null;
	%TextureRect.scale = Vector2(1,1);
	%TextureRect.rotation_degrees = 0;
	
func change_attack_in_spot(attack_change: attack_parent, lock: bool):
	PlayerAutoload.attack_resources_in[get_index()]
	attack_resource_holding = attack_change
	%TextureRect.texture = attack_change.icon_texture
	%TextureRect.attack_resource = attack_change
	%TextureRect.locked = lock
	print("change attack in spot")

# This function handles setting and animating the updated texture of the spot
func _spot_dropped(attack_resource: attack_parent, dropped_where_name: String):
	current_texture = %TextureRect.texture
	if dropped_where_name == name:
		if tween:
			tween.kill();
		tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true);
		tween.tween_property(%TextureRect, "scale", Vector2(1,1), 0.1).from(Vector2(0.9,0.9))
		await tween.finished;
