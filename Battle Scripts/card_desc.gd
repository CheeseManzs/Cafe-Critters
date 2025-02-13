extends RichTextLabel
@export var customToolTip: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _make_custom_tooltip(tooltipText):
	var tooltip: CardTooltip = customToolTip.instantiate()
	tooltip.richtext.text = "[center]"+tooltipText+"[/center]"
	return tooltip
