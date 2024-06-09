extends MarginContainer

@onready var calculator := get_node("/root/Calculator")

@onready var background := $Background
@onready var coloredHexagon := $HBoxContainer/Left/AspectRatioContainer/ColoredHexagon
@onready var foodNameLabel := $HBoxContainer/Middle/FoodName
@onready var multiplierLabel := $HBoxContainer/Middle/HBoxContainer/Multiplier
@onready var weightLabel := $HBoxContainer/Right/Weight
@onready var gramsOfCarbsLabel := $HBoxContainer/Right/Weight/GramsOfCarbs

@onready var highlightRight := $HighlightRight
@onready var highlightLeft := $HighlightLeft

@onready var doseDivisionToggle := $HBoxContainer/Middle/HBoxContainer/MarginContainer/DoseDivisionToggle


var itemListIndex: int = 0
var highlightedSide: int = 0  # -1: left side highlighted, 0: not highlighted, 1: right side highlighted

var hexagonColor: Color = Color(0.1, 0.1, 0.1)
var foodName: String = ""
# following vars are strings since the user can input invalid floats before having
# inputted the entire number, like "." when trying to write ".5"
var multiplier: String = "n/a"
var weight: String = "0"

var splitDose = true
var gramsOfCarbs: float = 0


func _ready() -> void:
	UpdateValues()


func UpdateValues() -> void:
	
	background.color = Color(0.32, 0.4, 0.53) if itemListIndex % 2 == 0 else Color(0.42, 0.5, 0.63)
	
	coloredHexagon.modulate = hexagonColor
	
	foodNameLabel.text = foodName
	foodNameLabel.UpdateFontSize()
	multiplierLabel.text = "("+multiplier+")"
	weightLabel.text = weight
	
	if multiplier.is_valid_float() and weight.is_valid_float():
		# multiply together and display 1 decimal
		gramsOfCarbs = float(multiplier) * float(weight)
		gramsOfCarbsLabel.text = "(" + str(int(round(gramsOfCarbs))) + ")"
	else:
		gramsOfCarbs = NAN
		gramsOfCarbsLabel.text = "(nan)"
	
	highlightRight.visible = (highlightedSide == 1)
	highlightLeft.visible = (highlightedSide == -1)
	
	doseDivisionToggle.set_pressed_no_signal(not splitDose)
	
	doseDivisionToggle.visible = Settings.useTwoDoses
	

func NumberInput(input: String) -> void:
	var highlightedNumber := weight if highlightedSide == 1 else multiplier
	
	# remove placeholder text irregardless of input
	if highlightedNumber == "n/a" or highlightedNumber == "0":
		if highlightedSide == 1: weight = ""
		else: multiplier = ""
	
	highlightedNumber = weight if highlightedSide == 1 else multiplier
	
	if input == "backspace":
		if len(highlightedNumber) > 0:  # has to be a seperate if clause due to elif & else
			if highlightedSide == 1: weight = weight.substr(0, len(weight) - 1)
			else: multiplier = multiplier.substr(0, len(multiplier) - 1)
	
	elif input == ".":
		if "." not in highlightedNumber:  # has to be a seperate if clause due to elif & else
			if highlightedNumber == "":  # make sure that a zero exists before the period
				if highlightedSide == 1: weight = "0"
				else: multiplier = "0"
			if highlightedSide == 1: weight += "."
			else: multiplier += "."
	
	else:
		if highlightedSide == 1: weight += input
		else: multiplier += input
	
	
	UpdateValues()


func _on_dose_division_toggle_toggled(button_pressed: bool) -> void:
	splitDose = not button_pressed
	calculator.UpdateItems()
