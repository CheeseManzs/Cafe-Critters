class_name BulkDisplay
extends Control

@export var cardContainer: GridContainer
@export var background: Control
@export var openingCurve: Curve

static var display_scale = 0.8
var open = false
var openTimer: float = 0.0
static var maxTimer = 0.5
var childCount = 0

func isFullyOpen() -> bool:
	return openTimer >= maxTimer

func isFullyClosed() -> bool:
	return openTimer <= 0

func reset():
	for child in cardContainer.get_children():
		child.queue_free()
		childCount -= 1

func addCardDisplay(cardDisplay: CardDisplay):
	var subContainer: Control = Control.new()
	#subContainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#cardDisplay.custom_minimum_size = cardDisplay.size*0.5
	var oldSize = cardDisplay.size
	cardContainer.add_child(subContainer)
	subContainer.add_child(cardDisplay)
	subContainer.size_flags_horizontal = Control.SIZE_SHRINK_CENTER | Control.SIZE_EXPAND
	cardDisplay.custom_minimum_size = oldSize
	#cardDisplay.scaleFactor = 1
	cardDisplay.pivot_offset.x = cardDisplay.size.x / 2
	cardDisplay.position = -cardDisplay.pivot_offset
	childCount += 1

func _process(delta: float):
	if open && openTimer < maxTimer:
		openTimer += delta
	
	if !open && openTimer > 0:
		openTimer -= delta
	
	var openRatio = clampf(openTimer/maxTimer, 0, 1)
	position.y = 1.5*size.y*(1 - openingCurve.sample(openRatio))
	
	if isFullyClosed() && childCount > 0 && !open:
		reset()
		
	pass
