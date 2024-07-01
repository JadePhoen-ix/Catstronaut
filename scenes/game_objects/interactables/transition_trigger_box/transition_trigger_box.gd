extends Area2D


@export var next_scene: PackedScene

var triggered := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func trigger_transition() -> void:
	ScreenTransition.transition_to_scene(next_scene)


func _on_body_entered(body: Node2D) -> void:
	trigger_transition()


