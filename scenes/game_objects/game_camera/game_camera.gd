extends Camera2D


var target_position := Vector2.ZERO

@export_range(0.0, 100.0, 10.0) var pan_speed := 30.0
@export var player_offset := Vector2.ZERO
@export_color_no_alpha var background_color := Color.CORNFLOWER_BLUE


func _ready() -> void:
	make_current()
	RenderingServer.set_default_clear_color(background_color)


func _process(delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	target_position = player.global_position - player_offset
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * pan_speed))


