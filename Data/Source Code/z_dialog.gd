class_name ZDialog
extends Resource
## ZDialogs are just an array that holds multiple ZTexts.


@export var texts: Array[ZText]
var placeholder: Array[ZText] = []

func _init(p_texts = placeholder):
	texts = p_texts
	
func toDialog():
	return self
