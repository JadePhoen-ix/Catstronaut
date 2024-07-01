extends CanvasLayer


@export var prompt_strings: Array[String] = []


func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)
	ScreenTransition.transitioned_halfway.connect(_on_transitioned_halfway)


func _on_player_died() -> void:
	if prompt_strings.size() > 0:
		%PomptLabel.text = prompt_strings.pick_random()
	$AnimationPlayer.play("default")


func _on_transitioned_halfway() -> void:
	$AnimationPlayer.play("RESET")
