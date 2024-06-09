extends Control

@onready var calculatorNode = get_node("/root/Calculator")
@onready var typesListNode = get_parent().get_parent().get_parent().get_parent().get_parent()  # kill me
@onready var background = $Background
@onready var foodNameLabel = $HBoxContainer/VBoxContainer/HBoxContainer/FoodName
@onready var multiplierLabel = $HBoxContainer/VBoxContainer/HBoxContainer2/MarginContainer3/Multiplier
@onready var coloredHexagon = $HBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/AspectRatioContainer/ColoredHexagon
@onready var favoriteButton = $HBoxContainer/VBoxContainer/HBoxContainer2/MarginContainer2/Favorite

var itemListIndex: int = 0:
	set(value):
		itemListIndex = value
		background.color = Color(0.85, 0.72, 0.62) if itemListIndex % 2 == 0 else Color(0.95, 0.82, 0.72)

var foodName: String = "n/a"
var multiplier: String = "n/a"
var hexagonColor: Color = Color(0.1, 0.1, 0.1)
var isFavorited: bool = false


func _ready() -> void:
	UpdateDisplay()


func Delete() -> void:
	# deletes self
	RemoveFromFavorites()
	typesListNode.DeleteTypeWithIndex(itemListIndex)


func UpdateDisplay() -> void:
	foodNameLabel.text = foodName
	foodNameLabel.UpdateFontSize()
	multiplierLabel.text = "("+multiplier+")"
	coloredHexagon.modulate = hexagonColor
	favoriteButton.set_pressed_no_signal(isFavorited)


func RemoveFromFavorites() -> void:
	# note that this does NOT cause an error if the value to delete does not exist
	var typeData := [foodName, multiplier, hexagonColor]
	typesListNode.favorites.erase(typeData)


func _on_favorite_toggled(button_pressed: bool) -> void:
	isFavorited = button_pressed
	
	var typeData := [foodName, multiplier, hexagonColor]
	if isFavorited:
		if typeData not in typesListNode.favorites:
			typesListNode.favorites.append(typeData)
	else:
		RemoveFromFavorites()
	
	typesListNode.SaveLoadedTypesToFile()


func _on_use_pressed() -> void:
	calculatorNode.CreateItemNode(foodName, multiplier, hexagonColor, "0", true)
	typesListNode.visible = false
