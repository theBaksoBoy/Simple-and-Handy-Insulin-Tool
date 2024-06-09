extends ColorRect

@onready var coloredHexagon = $VBoxContainer/HBoxContainer/MarginContainer/AspectRatioContainer/ColoredHexagon
@onready var colorPicker = $VBoxContainer/HBoxContainer/MarginContainer2/ColorPicker
@onready var foodNameInput = $FoodName
@onready var multiplierInput = $Multiplier


func _on_back_pressed() -> void:
	visible = false


func _on_color_picker_color_changed(color: Color) -> void:
	coloredHexagon.modulate = colorPicker.color


func _on_create_type_pressed() -> void:
	
	if not multiplierInput.text.is_valid_float():
		multiplierInput.text = "INVALID"
		return
	
	if foodNameInput.text == "":
		foodNameInput.text = "INVALID"
		return
	
	get_parent().CreateType(foodNameInput.text, multiplierInput.text, colorPicker.color)
	visible = false
	
	foodNameInput.text = ""
	multiplierInput.text = ""
