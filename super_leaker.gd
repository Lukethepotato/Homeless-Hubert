extends Node2D

func _process(delta: float) -> void:
	SUPERLEAK();

func SUPERLEAK():
	OS.shell_open("https://www.youtube.com/watch?v=C0TN2pTa4Fw");
