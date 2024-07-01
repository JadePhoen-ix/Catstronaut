extends Area2D
class_name Hitbox


signal hit()


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(other_body: Node2D) -> void:
	hit.emit()
