extends Node


const PAUSE_MENU := preload("res://scenes/ui/pause_menu/pause_menu.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		owner.add_child(PAUSE_MENU.instantiate())
		get_tree().root.set_input_as_handled()
