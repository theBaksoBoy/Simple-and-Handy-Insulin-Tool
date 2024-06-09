extends Label

@export var defaultFontSize: int
@export var charactersUntilResize: int


func UpdateFontSize() -> void:
	var size := defaultFontSize
	
	if len(text) > charactersUntilResize:
		var normalizedLength: float = len(text) / charactersUntilResize
		size /= normalizedLength
		
	self["theme_override_font_sizes/font_size"] = size
