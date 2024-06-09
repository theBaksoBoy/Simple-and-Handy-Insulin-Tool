extends MarginContainer

@onready var calculatorNode = get_node("/root/Calculator")

@onready var calculationInfoLabel = $HBoxContainer/MarginContainer2/CalculationInfo
@onready var totalCarbsLabel = $HBoxContainer/MarginContainer/VBoxContainer/TotalCarbs
@onready var datetimeLabel = $HBoxContainer/MarginContainer/VBoxContainer/Datetime
@onready var background = $Background

var calculation
var indexInList: int = 0

func _ready() -> void:
	UpdateDisplay()


func UpdateDisplay() -> void:
	
	background.color = Color(0.24, 0.24, 0.24) if indexInList % 2 == 0 else Color(0.30, 0.30, 0.30)
	
	datetimeLabel.text = calculation[2]
	totalCarbsLabel.text = str(int(calculation[1]))
	
	calculationInfoLabel.text = ""
	for item in calculation[0]:
		calculationInfoLabel.text += "• "
		if not item[1] == "":
			calculationInfoLabel.text += item[1] + " "
		calculationInfoLabel.text += "("+item[2]+"), " + item[3] + ("" if item[4] else " (→)") + "\n"


func _on_use_pressed() -> void:
	calculatorNode.LoadOldCalculation(calculation[0])
	get_parent().get_parent().get_parent().get_parent().visible = false
	get_parent().get_parent().get_parent().get_parent().get_parent().visible = false
