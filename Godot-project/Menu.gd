extends ColorRect

@onready var weightPerUnitOfInsulinInput = $WeightPerUnitOfInsulinInput
@onready var doseCountButton = $DoseCountButton


func SaveSettings() -> void:
	
	if not weightPerUnitOfInsulinInput.text.is_valid_float():
		weightPerUnitOfInsulinInput.text = "INVALID"
		return
	
	Settings.SaveSettings(float(weightPerUnitOfInsulinInput.text), doseCountButton.button_pressed)
	
	%Dose.UpdateDisplays()


func UpdateDisplay() -> void:
	weightPerUnitOfInsulinInput.text = str(Settings.weightPerUnitOfInsulin)
	doseCountButton.set_pressed_no_signal(Settings.useTwoDoses)


func _on_back_pressed() -> void:
	visible = false


func _on_menu_pressed() -> void:
	UpdateDisplay()
	visible = true


func _on_save_settings_button_pressed() -> void:
	
	if not weightPerUnitOfInsulinInput.text.is_valid_float():
		weightPerUnitOfInsulinInput.text = "INVALID"
		return
	
	Settings.SaveSettings(float(weightPerUnitOfInsulinInput.text), doseCountButton.button_pressed)
	
	visible = false
	
	%Dose.UpdateDisplays()
