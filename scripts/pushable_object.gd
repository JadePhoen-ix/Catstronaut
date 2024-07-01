extends CharacterBody2D
class_name PushableObject


@export_range(0.0, 10000.0, 5.0) var push_force := 5200.0
@export_range(10.0, 10000.0, 10.0) var gravity := 960.0

var is_flipped: bool:
	get: return !up_direction.y == -1

var is_falling: bool:
	get:
		if is_flipped:
			return velocity.y < 0.0
		else:
			return velocity.y > 0.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Deceleration / fake friction
	velocity.x = lerp(0.0, velocity.x, pow(2.0, -15.0 * get_process_delta_time()))
	
	move_and_slide()
	
	if is_falling:
		velocity.x = 0.0


func push(direction: Vector2) -> void:
	if is_falling:
		return
	
	velocity = direction * push_force * get_process_delta_time()



