extends Node2D
class_name Interactable


signal was_interacted()


## "Public" method called by interacting objects.
func trigger_interactable() -> void:
	_interaction()


## Meant to be overwritten to define interaction logic.
func _interaction() -> void:
	pass

