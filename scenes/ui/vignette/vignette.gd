extends CanvasLayer


@onready var animation_player := $AnimationPlayer as AnimationPlayer


func _on_player_damaged() -> void:
	animation_player.play("hit")


