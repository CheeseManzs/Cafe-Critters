extends Panel
var timer = 0
var speed = 1.5
var isOpening = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# generic animatng code.
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	#var processVal = 1
	var processVal = sin(PI * timer / 2)
	anchor_top = 1.65 - (processVal)
	anchor_bottom = 1.98 - (processVal)
	pass
