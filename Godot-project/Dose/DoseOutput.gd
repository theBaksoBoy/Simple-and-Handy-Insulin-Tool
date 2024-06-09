extends Control

@onready var doseLabel = $Dose
@onready var doseExtraLabel = $DoseExtra

var dose: float = 0:
	set(value):
		dose = value
		UpdateDisplay()

var extra: float = 0


func _ready() -> void:
	UpdateDisplay()


func UpdateDisplay() -> void:
	doseExtraLabel.text = "("+("+" if extra >= 0 else "")+("%.1f" % extra)+")"
	doseLabel.text = "%.1f" % (dose + extra)


func _on_plus_pressed() -> void:
	extra += 0.1
	UpdateDisplay()


func _on_minus_pressed() -> void:
	extra -= 0.1
	UpdateDisplay()
