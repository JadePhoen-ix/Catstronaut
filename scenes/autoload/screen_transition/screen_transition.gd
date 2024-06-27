extends CanvasLayer


signal transitioned_halfway()

@onready var animation_player := $AnimationPlayer as AnimationPlayer


func transition() -> void:
	animation_player.play("default")
	await animation_player.animation_finished
	transitioned_halfway.emit()
	animation_player.play_backwards("default")


func transition_to_scene(scene_path: String) -> void:
	transition()
	await transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)


