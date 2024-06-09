extends ColorRect


func _on_delete_pressed() -> void:
	visible = true
	
	
func _on_cancel_pressed() -> void:
	visible = false


func _on_confirm_delete_pressed() -> void:
	get_parent().Delete()
