extends CharacterBody2D


@export_range(0.0, 1000.0, 5.0) var jump_speed := 335.0
@export_range(10.0, 3000.0, 10.0) var gravity := 960.0

var adjusted_gravity := gravity
var jump_cancel_multiplier := 3.0

var is_flipped: bool:
	get: return !up_direction.y == -1

var is_falling: bool:
	get:
		if is_flipped:
			return velocity_2d.velocity.y < 0.0
		else:
			return velocity_2d.velocity.y > 0.0

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var land_animation_player := $LandAnimationPlayer as AnimationPlayer
@onready var velocity_2d := $Velocity2D as Velocity2D
@onready var visuals := $Pivot as Node2D


func _process(delta: float) -> void:
	var movement_vector := get_movement_vector()
	var was_grounded_last_frame := is_on_floor()
	
	velocity_2d.accelerate_in_direction(movement_vector)
	
	if movement_vector.y < 0.0 and is_on_floor():
		var jump_direction := -1 if is_flipped else 1
		velocity_2d.velocity.y = (movement_vector.y * jump_speed) * jump_direction
	
	if not is_falling and not Input.is_action_pressed("jump"):
		velocity_2d.velocity.y += adjusted_gravity * jump_cancel_multiplier * delta
	else:
		velocity_2d.velocity.y += adjusted_gravity * delta
	
	velocity_2d.move(self)
	
	var move_sign := signf(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, visuals.scale.y)
	
	update_animation(movement_vector, (not was_grounded_last_frame and is_on_floor()))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reverse_gravity"):
		($Pivot as Node2D).scale.y *= -1
		adjusted_gravity *= -1
		up_direction *= -1
		animation_player.play("flip")


func get_movement_vector() -> Vector2:
	var movement_vector := Vector2.ZERO
	movement_vector.x = Input.get_axis("move_left", "move_right")
	movement_vector.y = -1.0 if Input.is_action_just_pressed("jump") else 0.0
	return movement_vector


func update_animation(movement_vector: Vector2, just_landed: bool) -> void:
	if just_landed:
		land_animation_player.play("land")
	
	if animation_player.current_animation == "flip" and animation_player.is_playing():
		return
	
	if animation_player.current_animation == "jump" and animation_player.is_playing():
		return
	
	if is_falling:
		animation_player.play("fall")
	elif movement_vector.y == up_direction.y:
		animation_player.play("jump")
	elif movement_vector.x != 0.0:
		animation_player.play("run")
	else:
		animation_player.play("RESET")







