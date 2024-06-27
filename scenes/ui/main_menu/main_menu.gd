extends CanvasLayer


const MAIN_SCENE_PATH := "res://scenes/main/main.tscn"
const META_UPGRADE_MENU_PATH := "res://scenes/ui/meta_upgrade_menu/meta_upgrade_menu.tscn"
const OPTIONS_MENU_SCENE := preload("res://scenes/ui/options_menu/options_menu.tscn")

@onready var play_button := $%PlayButton as Button
@onready var upgrades_button := $%UpgradesButton as Button
@onready var options_button := $%OptionsButton as Button
@onready var menu_container := $MenuContainer as MarginContainer


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	upgrades_button.pressed.connect(_on_upgrades_pressed)
	options_button.pressed.connect(_on_options_pressed)


func _on_play_pressed() -> void:
	ScreenTransition.transition_to_scene(MAIN_SCENE_PATH)


func _on_upgrades_pressed() -> void:
	ScreenTransition.transition_to_scene(META_UPGRADE_MENU_PATH)


func _on_options_pressed() -> void:
	var options_instance := OPTIONS_MENU_SCENE.instantiate() as OptionsMenu
	add_child(options_instance)
	options_instance.back_button_pressed.connect(_on_options_closed.bind(options_instance))
	menu_container.modulate = Color.TRANSPARENT


func _on_options_closed(options_instance: OptionsMenu) -> void:
	options_instance.queue_free()
	menu_container.modulate = Color.WHITE

