extends Node3D

# storedSpeech should ALWAYS be a ZDialog or ZText resource.
@export var storedSpeech: Resource = ZDialog.new()
var storedSpeech2: ZDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Converts storedSpeech into a ZDialog if its a ZText. Dialog handling only works with ZDialog.
	if storedSpeech.has_method("toDialog"):
		storedSpeech2 = storedSpeech.toDialog()
		print(storedSpeech2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interactSpeak():
	return storedSpeech2
	pass
