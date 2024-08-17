extends Panel

#connected monster object
@export var connectedMon: Node
#object's text label for the monster's name
@export var connectedLabel: RichTextLabel
#object's progress bar
@export var connectedBar: ProgressBar

func reloadUI() -> void:
	connectedLabel.text = "Mon"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
