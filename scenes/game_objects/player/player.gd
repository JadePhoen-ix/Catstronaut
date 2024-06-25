extends CharacterBody2D


@export_range(0.0, 300.0, 5.0) var max_speed := 100.0
@export_range(0.0, 1000.0, 5.0) var jump_speed := 100.0
@export_range(10.0, 3000.0, 10.0) var horizontal_acceleration := 1500.0
@export_range(10.0, 3000.0, 10.0) var gravity := 600.0

var adjusted_gravity := gravity

@onready var velocity_2d := $Velocity2D as Velocity2D


func _process(delta: float) -> void:
	var move_vector := Vector2.ZERO
	move_vector.x = Input.get_axis("move_left", "move_right")
	move_vector.y = -1.0 if Input.is_action_just_pressed("jump") else 0.0
	
	velocity.x += move_vector.x * horizontal_acceleration * delta
	
	if move_vector.x == 0:
		velocity.x = lerp(0.0, velocity.x, pow(2.0, -15.0 * delta))
	
	velocity.x = clampf(velocity.x, -max_speed, max_speed)
	
	if move_vector.y < 0.0 and is_on_floor():
		velocity.y = move_vector.y * jump_speed
	
	velocity.y += gravity * delta
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reverse_gravity"):
		gravity *= -1
		up_direction *= -1
		jump_speed *= -1
		
		($Sprite2D as Sprite2D).flip_v = !($Sprite2D as Sprite2D).flip_v
		
		GameEvents.emit_reverse_gravity_pressed()


