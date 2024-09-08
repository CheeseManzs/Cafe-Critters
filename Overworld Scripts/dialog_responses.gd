extends VBoxContainer
var timer = 0
var speed = 3
var isOpening = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anchor_right = 1.4
	anchor_left = 1.2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	
	var processVal = sin(PI * timer / 2)
	anchor_left = 1.2 - (0.4 * processVal)
	anchor_right = 1.4 - (0.4 * processVal) 
	
	pass
