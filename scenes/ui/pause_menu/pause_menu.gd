extends CanvasLayer


const OPTIONS_MENU_SCENE := preload("res://scenes/ui/options_menu/options_menu.tscn")

var is_closing := false

@onready var resume_button := $%ResumeButton as Button
@onready var restart_button := %RestartButton as Button
@onready var options_button := $%OptionsButton as Button
@onready var main_menu_button := $%MainMenuButton as Button
@onready var screen_darken := $ScreenDarken as ScreenDarken
@onready var panel_container := %PanelContainer as PanelContainer


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2.0
	
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	options_button.pressed.connect(_on_options_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	
	var tween := create_tween()
	
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close() -> void:
	if is_closing:
		return
	
	is_closing = true
	screen_darken.play_out()
	
	var tween := create_tween()
	
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()


func _on_resume_pressed() -> void:
	close()


func _on_restart_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_options_pressed() -> void:
	var options_instance := OPTIONS_MENU_SCENE.instantiate() as OptionsMenu
	options_instance.back_button_pressed.connect(_on_options_closed.bind(options_instance))
	add_child(options_instance)
	
	panel_container.modulate = Color.TRANSPARENT


func _on_main_menu_pressed() -> void:
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu/main_menu.tscn")


func _on_options_closed(options_instance: OptionsMenu) -> void:
	options_instance.queue_free()
	panel_container.modulate = Color.WHITE


