extends Node

const SETTINGS_PATH = "user://settings.data"

var weightPerUnitOfInsulin: float = 10
var useTwoDoses: bool = true


func _ready() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		LoadSettings()  # load settings during start of program
	else:
		SaveSettings(10, true)  # make settings file if it doesn't exist
		LoadSettings()


func SaveSettings(_weightPerUnitOfInsulin, _useTwoDoses) -> void:
	
	weightPerUnitOfInsulin = _weightPerUnitOfInsulin
	useTwoDoses = _useTwoDoses
	
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_var([weightPerUnitOfInsulin, useTwoDoses])
	file.close()
	
	get_node("/root/Calculator").UpdateItems()


func LoadSettings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	var varsFromFile = file.get_var()
	file.close()

	weightPerUnitOfInsulin = varsFromFile[0]
	useTwoDoses = varsFromFile[1]
