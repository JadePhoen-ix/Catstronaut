extends CanvasLayer


const MAIN_SCENE_PATH := "res://scenes/puzzles/puzzle_intro/puzzle_intro.tscn"
const OPTIONS_MENU_SCENE := preload("res://scenes/ui/options_menu/options_menu.tscn")
const MAIN_MENU_SONG := preload("res://assets/audio/music/main_menu.wav")

var camera_offset := Vector2.ZERO

@onready var play_button := $%PlayButton as Button
@onready var options_button := $%OptionsButton as Button
@onready var menu_container := $MenuContainer as MarginContainer
@onready var camera_2d := $Camera2D as Camera2D


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	
	MusicPlayer.set_music(MAIN_MENU_SONG)


func _process(delta: float) -> void:
	camera_offset.x += 30.0 * delta
	camera_2d.global_position = camera_offset


func _on_play_pressed() -> void:
	ScreenTransition.transition_to_scene(MAIN_SCENE_PATH)


func _on_options_pressed() -> void:
	var options_instance := OPTIONS_MENU_SCENE.instantiate() as OptionsMenu
	options_instance.back_button_pressed.connect(_on_options_closed.bind(options_instance))
	add_child(options_instance)
	
	menu_container.modulate = Color.TRANSPARENT


func _on_options_closed(options_instance: OptionsMenu) -> void:
	options_instance.queue_free()
	menu_container.modulate = Color.WHITE

