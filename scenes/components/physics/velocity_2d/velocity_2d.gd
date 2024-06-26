extends Node
class_name Velocity2D


@export_range(0.0, 300.0, 5.0) var max_speed := 125.0
@export_range(10.0, 3000.0, 10.0) var acceleration := 1500.0

var velocity := Vector2.ZERO


func accelerate_in_direction(move_vector: Vector2) -> void:
	velocity.x += move_vector.x * acceleration * get_process_delta_time()
	
	if move_vector.x == 0:
		velocity.x = lerp(0.0, velocity.x, pow(2.0, -15.0 * get_process_delta_time()))
	
	velocity.x = clampf(velocity.x, -max_speed, max_speed)


func decelerate() -> void:
	accelerate_in_direction(Vector2.ZERO)


func move(body: CharacterBody2D) -> void:
	body.velocity = velocity
	body.move_and_slide()
	velocity = body.velocity

