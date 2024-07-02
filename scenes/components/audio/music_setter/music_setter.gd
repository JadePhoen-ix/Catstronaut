extends Node


@export var music_stream: AudioStream


func _ready() -> void:
	if music_stream == null:
		return
	
	MusicPlayer.set_music(music_stream)


