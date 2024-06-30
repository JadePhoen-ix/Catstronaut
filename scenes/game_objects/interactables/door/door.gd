@tool
extends Interactable


@export var start_open: bool:
	set(value):
		start_open = value
		open = value
		if Engine.is_editor_hint():
			sprite.frame = int(open) * 3
			door_collision_shape.disabled = open

var open: bool

@onready var animation_player := $AnimationPlayer as AnimationPlayer 
@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var door_collision_shape := $StaticBody2D/DoorCollisionShape2D as  CollisionShape2D
@onready var random_audio_2d := $RandomAudio2D as RandomAudio2D


func _ready() -> void:
	if start_open:
		sprite.frame = 3
		door_collision_shape.disabled = true


func _interaction() -> void:
	set_door_state(!open)


func set_door_state(value: bool) -> void:
	open = value
	
	if open:
		animation_player.play("default")
	else:
		animation_player.play_backwards("default")
	
	if is_inside_tree():
		random_audio_2d.play_random()


