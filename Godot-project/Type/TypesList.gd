extends Control

@onready var favoriteShortcuts = %FavoriteShortcuts

@onready var typeNodeContainer = $VBoxContainer/ScrollableArea/ScrollContainer/TypeNodeContainer
@onready var addNewTypeScreen = $AddNewTypeScreen
@onready var searchBar = $VBoxContainer/Buttons/SearchBar

const TYPES_PATH = "user://types.data"

var typesNodes: Array[Control] = []
var favorites: Array = []  # [[foodName, multiplier, hexagonColor], ...] smaller indices should appear first
var typeScene = preload("res://Type/type.tscn")



func _ready() -> void:
	if FileAccess.file_exists(TYPES_PATH):
		LoadTypesFromFile()  # load types during start of program
	else:
		SaveLoadedTypesToFile()  # make types file if it doesn't exist
		LoadTypesFromFile()


func _on_back_pressed() -> void:
	visible = false


func UpdateIndices() -> void:
	for i in range(len(typesNodes)):
		typesNodes[i].itemListIndex = i


func DeleteTypeWithIndex(i: int) -> void:
	typesNodes.pop_at(i).queue_free()
	UpdateIndices()
	SaveLoadedTypesToFile()


func SortByFirstIndex(a, b):
	var arr = [a[0], b[0]]
	arr.sort()
	return (a[0] == arr[0])


func SaveLoadedTypesToFile() -> void:
	# store all existing files in a nested array, where each array
	# entry contains all the variables of that type in its own array
	var typesData := []
	for type in typesNodes:
		typesData.append([type.foodName, type.multiplier, type.hexagonColor, type.isFavorited])
	
	var file = FileAccess.open(TYPES_PATH, FileAccess.WRITE)
	file.store_var([typesData, favorites])
	file.close()
	
	favoriteShortcuts.ReloadButtons()


func LoadTypesFromFile() -> void:
	var file = FileAccess.open(TYPES_PATH, FileAccess.READ)
	var varFromFile: Array = file.get_var()
	var readTypesData: Array = varFromFile[0]
	favorites = varFromFile[1]
	file.close()

	# remove all old type nodes
	while len(typesNodes) > 0:
		typesNodes.pop_at(0).queue_free()
	
	readTypesData.sort_custom(SortByFirstIndex)
	
	for typeData in readTypesData:
		var newTypeNode = typeScene.instantiate()
		newTypeNode.foodName = typeData[0]
		newTypeNode.multiplier = typeData[1]
		newTypeNode.hexagonColor = typeData[2]
		newTypeNode.isFavorited = typeData[3]
		
		typeNodeContainer.add_child(newTypeNode)
		typesNodes.append(newTypeNode)
	
	UpdateIndices()
	favoriteShortcuts.ReloadButtons()


func _on_add_type_pressed() -> void:
	addNewTypeScreen.visible = true


func CreateType(foodName: String, multiplier: String, hexagonColor: Color) -> void:
	
	var newTypeNode = typeScene.instantiate()
	newTypeNode.foodName = foodName
	newTypeNode.multiplier = multiplier
	newTypeNode.hexagonColor = hexagonColor
	newTypeNode.isFavorited = false
	
	typeNodeContainer.add_child(newTypeNode)
	typesNodes.append(newTypeNode)
	
	SaveLoadedTypesToFile()
	UpdateIndices()


func _on_search_bar_text_changed() -> void:
	
	var text: String = searchBar.text
	
	var allTypes = typeNodeContainer.get_children()
	
	# make all types visible if search bar is empty
	if text == "":
		for typeNode in allTypes:
			typeNode.visible = true
	
	# only make types with text as a substring visible
	else:
		for typeNode in allTypes:
			typeNode.visible = (text.to_lower() in typeNode.foodName.to_lower())
