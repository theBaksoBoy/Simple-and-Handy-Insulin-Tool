extends Control

@onready var calculatorNode = get_node("/root/Calculator")

@onready var background = $Background
@onready var foodNameLabel = $FoodName
@onready var coloredHexagon = $ColoredHexagon

var indexInList: int = 0

var foodName: String
var multiplier: String
var hexagonColor: Color

func _ready() -> void:
	UpdateDisplay()
	
	
func UpdateDisplay() -> void:
	foodNameLabel.text = foodName
	foodNameLabel.UpdateFontSize()
	coloredHexagon.modulate = hexagonColor
	background.color = Color(0.79, 0.63, 0.6) if indexInList % 2 == 0 else Color(0.89, 0.73, 0.7)


func _on_use_button_pressed() -> void:
	calculatorNode.CreateItemNode(foodName, multiplier, hexagonColor, "0", true)
