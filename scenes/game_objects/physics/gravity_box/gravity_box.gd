extends PushableObject


@export var start_inverted := false

@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D


func _ready() -> void:
	if start_inverted:
		invert_gravity()
	GameEvents.reverse_gravity_pressed.connect(_on_reverse_gravity_pressed)


func invert_gravity() -> void:
	gravity *= -1
	up_direction *= -1
	animated_sprite_2d.frame = 0 if animated_sprite_2d.frame == 1 else 1


func _on_reverse_gravity_pressed() -> void:
	invert_gravity()



