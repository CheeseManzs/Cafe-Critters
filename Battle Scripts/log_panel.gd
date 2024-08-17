class_name LogPanel
extends Panel

#text to display on log
var logText: String
#timer
var t = 0
#max time before removal
var lifeTime = 4
@export var richText: RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	richText.text = "   "+logText
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	#check if timer has counted past max time for removal
	if t > lifeTime:
		#delte node
		queue_free()
	pass
