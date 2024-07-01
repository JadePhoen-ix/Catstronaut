extends GPUParticles2D
class_name WireFX


@export_range(0.0, 3.0, 0.1) var emission_delay_min := 0.5
@export_range(0.0, 3.0, 0.1) var emission_delay_max := 1.5

var current_process_material: ParticleProcessMaterial:
	get: return process_material as ParticleProcessMaterial

@onready var spark_random_audio_2d := $SparkRandomAudio2D as RandomAudio2D


func _ready() -> void:
	var delay_timer := get_tree().create_timer(randf_range(emission_delay_min, emission_delay_max))
	delay_timer.timeout.connect(_on_delay_timer_timeout)


func set_direction(new_direction: Vector2):
	current_process_material.direction = Vector3(new_direction.x, new_direction.y, 0.0)


func start_emission_cycle() -> void:
	emitting = true
	spark_random_audio_2d.play_random()
	
	var delay_timer := get_tree().create_timer(randf_range(emission_delay_min, emission_delay_max))
	delay_timer.timeout.connect(_on_delay_timer_timeout)


func _on_delay_timer_timeout() -> void:
	start_emission_cycle()




