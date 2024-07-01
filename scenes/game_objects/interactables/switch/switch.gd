@tool
extends Interactable


@export var connected_interactables: Array[Interactable] = []
@export var start_on: bool:
	set(value):
		start_on = value
		on = value
		lever_sprite.rotation_degrees = 45 if on else -45

var on := false

@onready var lever_sprite := $LeverSprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer


func _interaction() -> void:
	if on:
		animation_player.play("off")
	else:
		animation_player.play("on")
	
	on = !on


func trigger_connected() -> void:
	for interactable in connected_interactables:
		if interactable == null:
			continue
		interactable.trigger_interactable()


