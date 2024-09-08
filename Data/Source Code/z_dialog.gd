class_name ZDialog
extends Resource

@export var texts: Array[ZText]
var placeholder: Array[ZText] = []

func _init(p_texts = placeholder):
	texts = p_texts
	
func toDialog():
	return self
