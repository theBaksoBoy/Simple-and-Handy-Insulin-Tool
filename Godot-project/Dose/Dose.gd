extends Control

@onready var doseOutput1 = $VBoxContainer/DoseOutput1
@onready var doseOutput2 = $VBoxContainer/DoseOutput2
@onready var doseLabel = $Dose

var totalCarbs: float = 0:
	set(value):
		totalCarbs = value
		UpdateDisplays()
var totalCarbsExclusiveSecondDose: float = 0:
	set(value):
		totalCarbsExclusiveSecondDose = value
		UpdateDisplays()


func _ready() -> void:
	UpdateDisplays()


func UpdateDisplays():
	
	var totalCarbsString = str(int(totalCarbs)) if not is_nan(totalCarbs) else "nan"
	doseLabel.text = "Dose:\n(" + totalCarbsString + ")"
	
	if Settings.useTwoDoses:
		
		doseOutput1.visible = true
		doseOutput2.visible = true
		
		doseOutput1.dose = (totalCarbs - totalCarbsExclusiveSecondDose) / Settings.weightPerUnitOfInsulin / 2
		doseOutput2.dose = (totalCarbs + totalCarbsExclusiveSecondDose) / Settings.weightPerUnitOfInsulin / 2
	
	else:
		
		doseOutput1.visible = true
		doseOutput2.visible = false
		
		doseOutput1.dose = totalCarbs / Settings.weightPerUnitOfInsulin
