extends RichTextLabel
@export var fillSizeOffset: Vector2
@export var comparison: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("par size:",get_parent().size)
	custom_minimum_size.x = get_parent().size.x - 20*2
	custom_minimum_size.y = get_content_height()
	pass
