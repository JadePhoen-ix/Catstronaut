extends Button


@onready var click_random_audio := $ClickRandomAudio as RandomAudio
@onready var hover_random_audio := $HoverRandomAudio as RandomAudio


func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)


func _on_pressed() -> void:
	click_random_audio.play_random()


func _on_mouse_entered() -> void:
	hover_random_audio.play_random()

