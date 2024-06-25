extends Node


signal reverse_gravity_pressed()


func emit_reverse_gravity_pressed() -> void:
	reverse_gravity_pressed.emit()

