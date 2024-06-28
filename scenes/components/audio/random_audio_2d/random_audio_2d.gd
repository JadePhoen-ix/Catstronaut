extends AudioStreamPlayer2D
class_name RandomAudio2D


@export var streams: Array[AudioStream]
@export var randomize_pitch := true
@export var max_pitch := 1.1
@export var min_pitch := 0.9


func play_random(pitch_modifier := 0.0) -> void:
	if streams == null || streams.size() == 0:
		return
	
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch) + pitch_modifier
	else:
		pitch_scale = 1 + pitch_modifier
	
	stream = streams.pick_random()
	play()


func play_at_index(index: int, pitch_modifier := 0.0) -> void:
	if streams == null || streams.size() == 0:
		return
	
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch) + pitch_modifier
	else:
		pitch_scale = 1 + pitch_modifier
	
	stream = streams[index]
	play()


