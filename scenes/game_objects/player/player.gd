extends CharacterBody2D


@export_range(0.0, 1000.0, 5.0) var jump_speed := 100.0
@export_range(10.0, 3000.0, 10.0) var gravity := 600.0

var adjusted_gravity := gravity

@onready var sprite := $Visuals/AnimatedSprite2D as AnimatedSprite2D
@onready var velocity_2d := $Velocity2D as Velocity2D
@onready var visuals := $Visuals as Node2D


func _process(delta: float) -> void:
	var movement_vector := Vector2.ZERO
	movement_vector.x = Input.get_axis("move_left", "move_right")
	movement_vector.y = -1.0 if Input.is_action_just_pressed("jump") else 0.0
	
	velocity_2d.accelerate_in_direction(movement_vector)
	
	if movement_vector.y < 0.0 and is_on_floor():
		velocity_2d.velocity.y = movement_vector.y * jump_speed
	
	velocity_2d.velocity.y += gravity * delta
	
	velocity_2d.move(self)
	
	var move_sign := signf(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, visuals.scale.y)


