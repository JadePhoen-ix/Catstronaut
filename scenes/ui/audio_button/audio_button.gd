extends Button


@onready var random_audio_component := $RandomAudioComponent as RandomAudioComponent


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	random_audio_component.play_random()
