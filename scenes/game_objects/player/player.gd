extends CharacterBody2D


@export_range(0.0, 1000.0, 5.0) var jump_speed := 335.0
@export_range(10.0, 3000.0, 10.0) var gravity := 960.0

var adjusted_gravity := gravity
var jump_cancel_multiplier := 3.0
var was_grounded_last_frame := true
var ready_timer: SceneTreeTimer

var is_flipped: bool:
	get: return !up_direction.y == -1

var is_falling: bool:
	get:
		if is_flipped:
			return velocity_2d.velocity.y < 0.0
		else:
			return velocity_2d.velocity.y > 0.0

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var coyote_timer := $CoyoteTimer as Timer
@onready var land_animation_player := $LandAnimationPlayer as AnimationPlayer
@onready var velocity_2d := $Velocity2D as Velocity2D
@onready var visuals := $Pivot as Node2D
@onready var flip_random_audio_2d := $FlipRandomAudio2D as RandomAudio2D


func _ready() -> void:
	ready_timer = get_tree().create_timer(0.1)


func _physics_process(delta: float) -> void:
	var movement_vector := get_movement_vector()
	was_grounded_last_frame = is_on_floor()
	
	velocity_2d.accelerate_in_direction(movement_vector)
	
	if movement_vector.y < 0.0 and (is_on_floor() or not coyote_timer.is_stopped()):
		var jump_direction := -1 if is_flipped else 1
		velocity_2d.velocity.y = (movement_vector.y * jump_speed) * jump_direction
	
	if not is_falling and not Input.is_action_pressed("jump"):
		velocity_2d.velocity.y += adjusted_gravity * jump_cancel_multiplier * delta
	else:
		velocity_2d.velocity.y += adjusted_gravity * delta
	
	velocity_2d.move(self)
	
	push_objects()
	
	if was_grounded_last_frame and not is_on_floor():
		coyote_timer.start()
	
	update_animation(movement_vector, (not was_grounded_last_frame and is_on_floor()))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reverse_gravity"):
		invert_gravity()
		GameEvents.emit_reverse_gravity_pressed()


func get_movement_vector() -> Vector2:
	var movement_vector := Vector2.ZERO
	movement_vector.x = Input.get_axis("move_left", "move_right")
	movement_vector.y = -1.0 if Input.is_action_just_pressed("jump") else 0.0
	return movement_vector


func invert_gravity() -> void:
	($Pivot as Node2D).scale.y *= -1
	adjusted_gravity *= -1
	up_direction *= -1
	
	flip_random_audio_2d.play_at_index(is_flipped)
	animation_player.play("flip")


func push_objects() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_normal() == up_direction:
			continue
		
		if collision.get_collider() is PushableObject:
			var collider := collision.get_collider() as PushableObject
			collider.push(Vector2(velocity.normalized().x, 0.0))


func update_animation(movement_vector: Vector2, just_landed: bool) -> void:
	var move_sign := signf(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, visuals.scale.y)
	
	if just_landed and ready_timer.time_left <= 0.0:
		land_animation_player.play("land")
	
	if animation_player.current_animation == "flip" and animation_player.is_playing():
		return
	
	if animation_player.current_animation == "jump" and animation_player.is_playing():
		return
	
	if is_falling:
		animation_player.play("fall")
	elif Input.is_action_just_pressed("jump"):
		animation_player.play("jump")
	elif movement_vector.x != 0.0 and is_on_floor():
		animation_player.play("run")
	else:
		animation_player.play("idle")


