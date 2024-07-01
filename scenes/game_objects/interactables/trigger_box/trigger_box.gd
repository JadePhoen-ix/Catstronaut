extends Area2D


@export var connected_interactables: Array[Interactable] = []

var triggered := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func trigger_connected() -> void:
	if triggered:
		return
	triggered = true
	
	for interactable in connected_interactables:
		interactable.trigger_interactable()


func _on_body_entered(body: Node2D) -> void:
	trigger_connected()
