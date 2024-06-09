extends Control

@onready var TypesListNode = %TypesList
@onready var itemContainer = %ItemContainer
@onready var doseNode = %Dose

var itemScene = preload("res://Item/item.tscn")

var items: Array = []

var highlightedItemIndex: int = -1:
	set(value):
		highlightedItemIndex = value
		UpdateItems()
		
var rightSideHighlighted: bool = true:
	set(value):
		rightSideHighlighted = value
		UpdateItems()


func UpdateItems() -> void:
	
	var totalCarbs: float = 0
	var totalCarbsExclusiveSecondDose: float = 0
	
	for i in range(len(items)):
		items[i].itemListIndex = i
		
		if i == highlightedItemIndex:
			items[i].highlightedSide = 1 if rightSideHighlighted else -1
		else:
			items[i].highlightedSide = 0
		
		items[i].UpdateValues()
		
		totalCarbs += items[i].gramsOfCarbs
		if not items[i].splitDose:
			totalCarbsExclusiveSecondDose += items[i].gramsOfCarbs
		
	doseNode.totalCarbs = totalCarbs
	doseNode.totalCarbsExclusiveSecondDose = totalCarbsExclusiveSecondDose


func NumberInput(input: String) -> void:
	
	if len(items) == 0:
		return
	
	items[highlightedItemIndex].NumberInput(input)


func CreateItemNode(foodName: String = "", multiplier: String = "n/a", hexagonColor: Color = Color(0.1, 0.1, 0.1), weight: String = "0", splitDose = true):
	var NewItemNode = itemScene.instantiate()
	NewItemNode.foodName = foodName
	NewItemNode.multiplier = multiplier
	NewItemNode.hexagonColor = hexagonColor
	NewItemNode.weight = weight
	NewItemNode.splitDose = splitDose
	items.append(NewItemNode)
	
	itemContainer.add_child(NewItemNode)
	
	highlightedItemIndex = len(items) - 1
	rightSideHighlighted = true
	
	# make sure that scroll container is scrolled down to the bottom whenever you add a new item
	await get_tree().process_frame  # wait one frame, as the scroll updates incorrectly otherwise
	itemContainer.get_parent().scroll_vertical = itemContainer.get_parent().get_v_scroll_bar().max_value


func LoadOldCalculation(itemsData):
	while len(items) > 0:
		items.pop_at(0).queue_free()
	
	for item in itemsData:
		CreateItemNode(item[1], item[2], item[0], item[3], item[4])

# ---------------- BUTTON FUNCTIONS ----------------

func _on_plus_pressed() -> void:
	CreateItemNode()


func _on_swap_pressed() -> void:
	rightSideHighlighted = not rightSideHighlighted


func _on_up_pressed() -> void:
	highlightedItemIndex -= 1
	if highlightedItemIndex < 0:
		highlightedItemIndex = len(items) - 1 
func _on_down_pressed() -> void:
	highlightedItemIndex += 1
	if highlightedItemIndex >= len(items):
		highlightedItemIndex = 0


func _on_delete_pressed() -> void:
	# delete the selected item
	
	if len(items) == 0:
		return
	
	items.pop_at(highlightedItemIndex).queue_free()
	
	if highlightedItemIndex >= len(items):
		highlightedItemIndex -= 1
	
	UpdateItems()


func _on_0_pressed() -> void: NumberInput("0"); UpdateItems()
func _on_point_pressed() -> void: NumberInput("."); UpdateItems()
func _on_1_pressed() -> void: NumberInput("1"); UpdateItems()
func _on_2_pressed() -> void: NumberInput("2"); UpdateItems()
func _on_3_pressed() -> void: NumberInput("3"); UpdateItems()
func _on_4_pressed() -> void: NumberInput("4"); UpdateItems()
func _on_5_pressed() -> void: NumberInput("5"); UpdateItems()
func _on_6_pressed() -> void: NumberInput("6"); UpdateItems()
func _on_7_pressed() -> void: NumberInput("7"); UpdateItems()
func _on_8_pressed() -> void: NumberInput("8"); UpdateItems()
func _on_9_pressed() -> void: NumberInput("9"); UpdateItems()
func _on_backspace_pressed() -> void: NumberInput("backspace"); UpdateItems()


func _on_ListTypes_pressed() -> void:
	TypesListNode.visible = true


func _on_save_pressed() -> void:
	
	var calculation := []
	
	for item in items:
		calculation.append([item.hexagonColor, item.foodName, item.multiplier, item.weight, item.splitDose])
	
	History.SaveCalculationToHistoryFile(calculation, doseNode.totalCarbs)
