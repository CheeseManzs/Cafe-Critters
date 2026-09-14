class_name Status_Burnout
extends Status

func _init() -> void:
	effect = EFFECTS.BURNOUT
	isNumerable = false

func p_nameMini() -> String:
	return "BNO"

func p_nameFull() -> String:
	return "Burnout"
