@tool
extends Interactable


@export var connected_interactables: Array[Interactable] = []
@export var start_on: bool:
	set(value):
		if Engine.is_editor_hint():
			start_on = value
			lever_sprite.rotation_degrees = 45 if on else -45

var on := false

@onready var lever_sprite := $LeverSprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var timer := $Timer as Timer


func _ready() -> void:
	if not Engine.is_editor_hint() and start_on:
		on = true
		lever_sprite.rotation_degrees = 45


func _interaction() -> void:
	if not timer.is_stopped():
		return
	timer.start()
	
	on = !on
	if on:
		animation_player.play("on")
	else:
		animation_player.play("off")


func trigger_connected() -> void:
	for interactable in connected_interactables:
		if interactable == null:
			continue
		interactable.trigger_interactable()


