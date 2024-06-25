extends Camera2D


var target_position := Vector2.ZERO

@export_range(1.0, 100.0, 0.1) var pan_speed := 30.0


func _ready() -> void:
	make_current()


func _process(delta: float) -> void:
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * pan_speed))


func acquire_target() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	target_position = player.global_position

