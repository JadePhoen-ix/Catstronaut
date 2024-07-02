extends AudioStreamPlayer


func set_music(music: AudioStream) -> void:
	stop()
	stream = music
	play()



