extends CanvasLayer


signal transitioned_halfway()

@onready var animation_player := $AnimationPlayer as AnimationPlayer


func transition() -> void:
	animation_player.play("default")
	await animation_player.animation_finished
	transitioned_halfway.emit()
	animation_player.play_backwards("default")


func transition_to_scene(scene: Variant) -> void:
	transition()
	await transitioned_halfway
	get_tree().paused = false
	
	if scene is String:
		get_tree().change_scene_to_file(scene)
	elif scene is PackedScene:
		get_tree().change_scene_to_packed(scene)
	else:
		printerr("Invalid param type for transition: Must be of type String or PackedScene.")


