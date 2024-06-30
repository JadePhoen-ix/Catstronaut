extends Interactable


@export var connected_interactables: Array[Interactable] = []

var on := false

@onready var area_2d := $Area2D as Area2D
@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D


func _ready() -> void:
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)


func _interaction() -> void:
	on = !on
	if on:
		animated_sprite_2d.frame = 2
	else:
		animated_sprite_2d.frame = 0
	trigger_connected()


func trigger_connected() -> void:
	for interactable in connected_interactables:
		interactable.trigger_interactable()


func on_body_entered(body: Node2D) -> void:
	trigger_interactable()


func on_body_exited(body: Node2D) -> void:
	trigger_interactable()

