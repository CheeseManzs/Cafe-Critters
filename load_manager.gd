class_name LoadManager

static var activeScene: Node
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static func loadScene(sceneName: String, currentScene:Node = null):
	if currentScene == null:
		currentScene = activeScene
	var loadingScreenScene: PackedScene = load("res://loading.tscn")
	
	var loading: LoadScreen = loadingScreenScene.instantiate()
	var parent: Node
	for child in currentScene.get_children():
		if child.is_class("Control"):
			parent = child
			child.add_child(loading)
	
	loading.position = Vector2(1920/4,1080/4)
	print(loading.position)
	await loading.canLoad
	var toLoad: PackedScene = load("res://"+sceneName+".tscn")
	print(sceneName)
	var newScene = toLoad.instantiate()
	parent.remove_child(loading)
	for child in newScene.get_children():
		if child.is_class("Control"):
			child.add_child(loading)
	
	var tree = currentScene.get_tree().root
	tree.add_child(newScene)
	loading.release = true
	currentScene.queue_free()
	activeScene = newScene
	
	

	
