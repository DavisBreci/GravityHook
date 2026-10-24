extends Node

const TILE_SIZE = 16
const PLAYER_TILE_SIZE = 2
const SETTINGS_PATH = "user://settings.cfg"
const PROGRESS_PATH = "user://progress.cfg"

var selected_level: PackedScene = preload("res://scenes/level_01.tscn")
var auto_level_prog: bool = false

var level_list: Array[PackedScene] = []
var best_times: Dictionary = {}

var volumes: Dictionary = {
	"Master": 0.5,
	"Music": 0.5,
	"SFX": 0.5
}

func _ready() -> void:
	load_settings()
	load_progress()

func load_settings() -> void:
	var config := ConfigFile.new()
	var error := config.load(SETTINGS_PATH)
	
	if error == OK:
		auto_level_prog = config.get_value(
			"gameplay", "auto_level_prog", false
		)
		for bus_name in volumes:
			volumes[bus_name] = clampf(
				float(config.get_value("audio", bus_name, volumes[bus_name])),
				0.0,
				1.0
			)
	elif error != ERR_FILE_NOT_FOUND:
		push_warning("Settings load error: %s" % error)
	for bus_name in volumes:
		apply_volume(bus_name)

func apply_volume(bus_name: String) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("Missing audio bus: " + bus_name)
		return
	AudioServer.set_bus_volume_linear(bus_index, volumes[bus_name])

func set_volume(bus_name: String, value: float) -> void:
	volumes[bus_name] = clampf(value, 0.0, 1.0)
	apply_volume(bus_name)
	save_settings()

func save_settings() -> void:
	var config := ConfigFile.new()
	for bus_name in volumes:
		config.set_value("audio", bus_name, volumes[bus_name])
	config.set_value("gameplay", "auto_level_prog", auto_level_prog)
	var error := config.save(SETTINGS_PATH)
	if error != OK:
		push_error("Save error: %s" % error)

func load_progress() -> void:
	var config := ConfigFile.new()
	var error := config.load(PROGRESS_PATH)
	if error == ERR_FILE_NOT_FOUND:
		return
	if error != OK:
		push_warning("Progress load error: %s" % error)
		return
	var saved: Variant = config.get_value("progress", "best_times", {})
	if saved is Dictionary:
		best_times = saved

func get_best_time(level_scene: PackedScene) -> float:
	if level_scene == null:
		return -1.0
	return float(best_times.get(level_scene.resource_path, -1.0))

func record_time(level_scene: PackedScene, finish_time: float) -> float:
	var previous_best := get_best_time(level_scene)
	if previous_best >= 0.0 and finish_time >= previous_best:
		return previous_best
	best_times[level_scene.resource_path] = finish_time
	var config := ConfigFile.new()
	config.set_value("progress", "best_times", best_times)
	var error := config.save(PROGRESS_PATH)
	if error != OK:
		push_error("Progress save error: %s" % error)
	return finish_time
