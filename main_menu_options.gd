extends Node

# This script manages the functionality of the options menu in the main menu. It converts slider values into decibels to modify the audio buses.

var master_index: int
var music_index: int
var sfx_index: int
var voice_index: int

func _ready() -> void:
	master_index = AudioServer.get_bus_index("Master");
	music_index = AudioServer.get_bus_index("Music");
	sfx_index = AudioServer.get_bus_index("Sound Effects");
	voice_index = AudioServer.get_bus_index("Voice/Voice Effects");
	$volume_settings/volume_sliders/master_audio_bar.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
	$volume_settings/volume_sliders/music_audio_bar.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))
	$volume_settings/volume_sliders/sfx_audio_bar.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index))
	$volume_settings/volume_sliders/voice_audio_bar.value = db_to_linear(AudioServer.get_bus_volume_db(voice_index))
	

func _on_master_audio_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))
	print("Master Volume: " +str(AudioServer.get_bus_volume_db(master_index)))

func _on_music_audio_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))
	print("Music Volume: " +str(AudioServer.get_bus_volume_db(music_index)))

func _on_sfx_audio_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))
	print("SFX Volume: " +str(AudioServer.get_bus_volume_db(sfx_index)))

func _on_voice_audio_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(voice_index, linear_to_db(value))
	print("Voice Volume: " +str(AudioServer.get_bus_volume_db(voice_index)))
