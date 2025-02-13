class_name CardTooltip
extends Control

@export var richtext: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	custom_minimum_size.y = 0
	custom_minimum_size.x = 30 + len(richtext.text)/3
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, 1.0, delta*16.0)
	custom_minimum_size.x = 500
	custom_minimum_size.y = lerp(custom_minimum_size.y*1.0, max(60.0, 40+richtext.get_content_height()*1.0), delta*16.0)
	pass
