extends PushableObject


@onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	GameEvents.reverse_gravity_pressed.connect(_on_reverse_gravity_pressed)


func invert_gravity() -> void:
	gravity *= -1
	up_direction *= -1
	
	#animation_player.play("flip")


func _on_reverse_gravity_pressed() -> void:
	invert_gravity()



