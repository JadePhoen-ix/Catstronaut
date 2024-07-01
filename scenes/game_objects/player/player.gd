extends CharacterBody2D


signal has_landed()

@export var start_inverted := false
@export_range(0.0, 1000.0, 5.0) var jump_speed := 335.0
@export_range(10.0, 3000.0, 10.0) var gravity := 960.0

var jump_cancel_multiplier := 3.0
var was_grounded_last_frame := true
var ready_timer: SceneTreeTimer
var is_flipping := false
var is_dead := false

var is_flipped: bool:
	get: return !up_direction.y == -1

var is_falling: bool:
	get:
		if is_flipped:
			return velocity_2d.velocity.y < 0.0
		else:
			return velocity_2d.velocity.y > 0.0

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var body_collision_shape_2d := $BodyCollisionShape2D as CollisionShape2D
@onready var coyote_timer := $CoyoteTimer as Timer
@onready var land_animation_player := $LandAnimationPlayer as AnimationPlayer
@onready var velocity_2d := $Velocity2D as Velocity2D
@onready var visuals := $Pivot as Node2D
@onready var flip_random_audio_2d := $FlipRandomAudio2D as RandomAudio2D
@onready var push_handler := $PushHandler as PushHandler
@onready var hitbox := $Hitbox as Hitbox


func _ready() -> void:
	ready_timer = get_tree().create_timer(0.1)
	hitbox.hit.connect(_on_hit)
	
	if start_inverted:
		invert_gravity(false)


func _physics_process(delta: float) -> void:
	if is_dead:
		update_animation(Vector2.ZERO, false)
		return
	
	var movement_vector := get_movement_vector()
	was_grounded_last_frame = is_on_floor()
	
	velocity_2d.accelerate_in_direction(movement_vector)
	
	if movement_vector.y < 0.0 and (was_grounded_last_frame or not coyote_timer.is_stopped()):
		var jump_direction := -1 if is_flipped else 1
		velocity_2d.velocity.y = (movement_vector.y * jump_speed) * jump_direction
	
	if not is_falling and not Input.is_action_pressed("jump"):
		velocity_2d.velocity.y += gravity * jump_cancel_multiplier * delta
	else:
		velocity_2d.velocity.y += gravity * delta
	
	velocity_2d.move(self)
	
	push_handler.push_objects(self)
	
	if was_grounded_last_frame and not is_on_floor():
		coyote_timer.start()
	
	var just_landed := not was_grounded_last_frame and is_on_floor()
	
	update_animation(movement_vector, just_landed)
	if is_flipping:
		is_flipping = !is_on_floor()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reverse_gravity") and not is_flipping:
		invert_gravity()
		GameEvents.emit_reverse_gravity_pressed()


func get_movement_vector() -> Vector2:
	var movement_vector := Vector2.ZERO
	movement_vector.x = Input.get_axis("move_left", "move_right") if not is_flipping else 0.0
	movement_vector.y = -1.0 if Input.is_action_just_pressed("jump") else 0.0
	
	return movement_vector


func invert_gravity(play_sfx := true) -> void:
	($Pivot as Node2D).scale.y *= -1
	gravity *= -1
	up_direction *= -1
	
	is_flipping = true
	body_collision_shape_2d.position.y += -2 if is_flipped else 2
	if play_sfx:
		flip_random_audio_2d.play_at_index(is_flipped)
	animation_player.play("flip")


func update_animation(movement_vector: Vector2, just_landed: bool) -> void:
	if is_dead:
		if not animation_player.is_playing():
			animation_player.play("death")
		return
	
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


func _on_hit() -> void:
	is_dead = true


