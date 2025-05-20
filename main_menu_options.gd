extends Node2D

var master_index: int
var music_index: int
var sfx_index: int
var voice_index: int


func _ready() -> void:
	master_index = AudioServer.get_bus_index("Master");
	music_index = AudioServer.get_bus_index("Music");
	sfx_index = AudioServer.get_bus_index("Sound Effects");
	voice_index = AudioServer.get_bus_index("Voice/Voice Effects");

func _on_master_audio_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))

func _on_music_audio_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))

func _on_sfx_audio_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))
	AudioServer.set_bus_volume_db(voice_index, linear_to_db(value))
