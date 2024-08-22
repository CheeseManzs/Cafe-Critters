extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func loadScene(sceneName: String) -> void:
	LoadManager.loadScene(sceneName, get_tree().current_scene)
	pass # Replace with function body.
