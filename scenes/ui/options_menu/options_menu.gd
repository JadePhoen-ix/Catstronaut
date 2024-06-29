extends CanvasLayer
class_name OptionsMenu


signal back_button_pressed()

@onready var master_slider := $%MasterSlider as HSlider
@onready var sfx_slider := $%SFXSlider as HSlider
@onready var music_slider := $%MusicSlider as HSlider
@onready var back_button := $%BackButton as Button
@onready var window_mode_button := %WindowModeButton as Button


func _ready() -> void:
	master_slider.value_changed.connect(_on_audio_slider_changed.bind("Master"))
	sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("SFX"))
	music_slider.value_changed.connect(_on_audio_slider_changed.bind("Music"))
	
	back_button.pressed.connect(_on_back_pressed)
	window_mode_button.pressed.connect(_on_window_mode_pressed)
	
	update_options_display()


func update_options_display() -> void:
	master_slider.value = get_bus_volume_percent("Master")
	sfx_slider.value = get_bus_volume_percent("SFX")
	music_slider.value = get_bus_volume_percent("Music")


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index := AudioServer.get_bus_index(bus_name)
	var volume_db := AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	var volume_db := linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_window_mode_pressed() -> void:
	var mode := DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		window_mode_button.text = "Fullscreen"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		window_mode_button.text = "Windowed"


func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percent(bus_name, value)


func _on_back_pressed() -> void:
	back_button_pressed.emit()


