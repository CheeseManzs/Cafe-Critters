class_name  LoadScreen
extends Control
@export var outerRect: Panel


var anim = false
var release = false
static var freeze = false
signal canLoad
var alpha = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	

	anim = true
	pass # Replace with function body.

func getCamera(node: Node) -> Camera3D:
	var children = node.get_children()
	for child in children:
		if child.is_class("Camera3D"):
			return child
		return getCamera(node)
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Vector2(0, 0)
	size = Vector2(1920, 1080)
	if anim:
		if !release:
			if alpha < 1:
				alpha += delta*3
			else:
				canLoad.emit()
		elif alpha > 0.01:
			if !freeze:
				alpha -= delta*2.0
		else:
			alpha = 0
			outerRect.modulate = Color(255, 255, 255, alpha)	
			queue_free()
	
	outerRect.modulate = Color(255, 255, 255, alpha)	
	pass
