extends Button


@onready var random_audio := $RandomAudio as RandomAudio


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	random_audio.play_random()
