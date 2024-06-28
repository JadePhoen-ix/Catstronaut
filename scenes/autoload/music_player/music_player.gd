extends AudioStreamPlayer


@onready var timer := $Timer as Timer


func _ready() -> void:
	finished.connect(_on_finished)
	timer.timeout.connect(_on_timer_timeout)


func set_music(music: AudioStream) -> void:
	playing = false
	stream = music
	playing = true


func _on_finished() -> void:
	timer.start()


func _on_timer_timeout() -> void:
	play()



