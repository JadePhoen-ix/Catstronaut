extends Area2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	(area.owner as Interactable).trigger_interactable()


