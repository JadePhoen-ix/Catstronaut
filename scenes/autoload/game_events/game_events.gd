extends Node


signal reverse_gravity_pressed()
signal player_died()


func emit_reverse_gravity_pressed() -> void:
	reverse_gravity_pressed.emit()


func emit_player_died() -> void:
	player_died.emit()


