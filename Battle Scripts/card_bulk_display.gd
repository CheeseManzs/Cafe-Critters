class_name BulkDisplay
extends Control

@export var cardContainer: Control
@export var background: Control

static var display_scale = 0.8

func addCardDisplay(cardDisplay: CardDisplay):
	#subContainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#cardDisplay.custom_minimum_size = cardDisplay.size*0.5
	var oldSize = cardDisplay.size
	cardContainer.add_child(cardDisplay)
	cardDisplay.custom_minimum_size = oldSize
	cardDisplay.scaleFactor = 1
