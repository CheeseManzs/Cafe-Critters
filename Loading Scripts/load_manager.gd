class_name LoadManager

static var activeScene: Node
static var savedScene: Node
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


static func restoreTemp(onLoad: Callable = func(x): return):
	var currentScene = activeScene

	var loadingScreenScene: PackedScene = load("res://Prefabs/loading.tscn")
	
	var loading: LoadScreen = loadingScreenScene.instantiate()
	var parent: Node
	for child in currentScene.get_children():
		if child.name == "Control UI":
			parent = child
			child.add_child(loading)
	
	loading.position = Vector2(1920/4,1080/4)
	await loading.canLoad
	
	var newScene = savedScene
	
	parent.remove_child(loading)
	for child in newScene.get_children():
		if child.name == "Control UI":
			child.add_child(loading)
			
	onLoad.call(newScene)
	var tree = currentScene.get_tree().root
	tree.add_child(newScene)
	loading.release = true
	
	var oldScene = currentScene
	oldScene.queue_free()
	
	activeScene = newScene

#loads scene without deleting the old one (disables it instead)
static func loadSceneTemp(sceneName: String, currentScene:Node = null, onLoad: Callable = func(x): return):
	if currentScene == null:
		currentScene = activeScene
	var loadingScreenScene: PackedScene = load("res://Prefabs/loading.tscn")
	
	var loading: LoadScreen = loadingScreenScene.instantiate()
	var parent: Node
	for child in currentScene.get_children():
		if child.name == "Control UI":
			parent = child
			child.add_child(loading)
	
	loading.position = Vector2(1920/4,1080/4)
	await loading.canLoad
	var toLoad: PackedScene = load("res://Scenes/"+sceneName+".tscn")
	print(sceneName)
	
	var newScene = toLoad.instantiate()
	parent.remove_child(loading)
	for child in newScene.get_children():
		if child.name == "Control UI":
			child.add_child(loading)
	onLoad.call(toLoad)
	var tree = currentScene.get_tree().root
	tree.add_child(newScene)
	loading.release = true
	
	savedScene = currentScene
	
	tree.remove_child(savedScene)

	activeScene = newScene


static func loadScene(sceneName: String, currentScene:Node = null, onLoad: Callable = func(x): return):
	if currentScene == null:
		currentScene = activeScene
	var loadingScreenScene: PackedScene = load("res://Prefabs/loading.tscn")
	
	var loading: LoadScreen = loadingScreenScene.instantiate()
	var parent: Node
	for child in currentScene.get_children():
		if child.name == "Control UI":
			parent = child
			child.add_child(loading)
	
	loading.position = Vector2(1920/4,1080/4)
	await loading.canLoad
	var toLoad: PackedScene = load("res://Scenes/"+sceneName+".tscn")
	print(sceneName)
	var newScene = toLoad.instantiate()
	parent.remove_child(loading)
	for child in newScene.get_children():
		if child.name == "Control UI":
			child.add_child(loading)
	onLoad.call(toLoad)
	var tree = currentScene.get_tree().root
	tree.add_child(newScene)
	loading.release = true
	currentScene.queue_free()
	activeScene = newScene
	
	

	
