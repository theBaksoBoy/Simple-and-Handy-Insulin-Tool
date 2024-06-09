extends ColorRect

@onready var historyCalculationContainer = $VBoxContainer/ScrollContainer/HistoryCalculationContainer

var historyCalculationScene = preload("res://History/history_calculation.tscn")

var historyCalculationNodes: Array


func _on_history_button_pressed() -> void:
	visible = true
	ReloadHistoryCalculations()


func _on_back_pressed() -> void:
	visible = false


func ReloadHistoryCalculations() -> void:
	
	while len(historyCalculationNodes) > 0:
		historyCalculationNodes.pop_at(0).queue_free()
	
	# loop through every history calculation in reverse order, 
	# to make more recent calculations appear at the top
	for i in range(len(History.history) - 1, -1, -1):
		
		var newHistoryCalculationNode = historyCalculationScene.instantiate()
		
		newHistoryCalculationNode.calculation = History.history[i]
		newHistoryCalculationNode.indexInList = i
		
		historyCalculationContainer.add_child(newHistoryCalculationNode)
		historyCalculationNodes.append(newHistoryCalculationNode)
