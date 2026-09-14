class_name Status_KO
extends Status

func _init() -> void:
	effect = EFFECTS.KO
	isNumerable = false

func p_nameMini() -> String:
	return "KO"

func p_nameFull() -> String:
	return "Knocked Out"
