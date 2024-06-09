extends Node

const HISTORY_PATH := "user://history.data"
const maxHistoryLength = 50

# array containing calculations. Each item is one whole calculation, which consists of an array.
# for an array in the history array:
# [0]: items is in the format [[hexagonColor: Color, foodName: String, multiplier: String, weight: String, splitDose: bool], ...]
# [1]: totalCarbs: float
# [2]: current datetime: String
var history: Array = []


func _ready() -> void:
	if FileAccess.file_exists(HISTORY_PATH):
		LoadHistoryFile()  # load history during start of program
	else:
		SaveHistoryFile()  # make history file if it doesn't exist
		LoadHistoryFile()


func SaveCalculationToHistoryFile(itemsData: Array, totalCarbs: float):
	# itemsData is in the format [[hexagonColor: Color, foodName: String, multiplier: String, weight: String, splitDose: bool], ...]
	
	var currentDatetime = Time.get_datetime_dict_from_system()
	
	var calculation := []
	calculation.append(itemsData)
	calculation.append(totalCarbs)
	calculation.append(str(currentDatetime["year"]) + "-" + str(currentDatetime["month"]) + "-" + str(currentDatetime["day"]) + " " + str(currentDatetime["hour"]) + ":" + str(currentDatetime["minute"]))
	
	while len(history) >= maxHistoryLength:
		history.pop_at(0)
	
	history.append(calculation)
	
	SaveHistoryFile()


func SaveHistoryFile():
	
	var file = FileAccess.open(HISTORY_PATH, FileAccess.WRITE)
	file.store_var(history)
	file.close()


func LoadHistoryFile():
	
	var file = FileAccess.open(HISTORY_PATH, FileAccess.READ)
	history = file.get_var()
	file.close()
