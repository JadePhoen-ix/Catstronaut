extends CharacterBody2D


@export var start_inverted := false
@export_range(10.0, 10000.0, 10.0) var gravity := 960.0

@onready var animated_sprite_2d := $AnimatedSprite2D as AnimatedSprite2D


var is_flipped_sideways: bool:
	get: return !up_direction.x == -1

var is_falling_sideways: bool:
	get:
		if is_flipped_sideways:
			return velocity.x < 0.0
		else:
			return velocity.x > 0.0


func _ready() -> void:
	if start_inverted:
		invert_gravity()
	GameEvents.reverse_gravity_pressed.connect(_on_reverse_gravity_pressed)


func _physics_process(delta: float) -> void:
	velocity.x -= gravity * delta
	
	velocity.y = 0.0
	
	move_and_slide()
	
	var player_detection := $PlayerDetection as Area2D
	if player_detection.has_overlapping_bodies():
		velocity = Vector2.ZERO
	
	$PushHandler.push_objects(self, up_direction.x)
	


func invert_gravity() -> void:
	gravity *= -1
	up_direction *= -1
	animated_sprite_2d.frame = 0 if animated_sprite_2d.frame == 1 else 1


func _on_reverse_gravity_pressed() -> void:
	invert_gravity()



