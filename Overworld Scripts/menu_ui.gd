extends Control
@export var menus: Array[Control]
static var lastDelta = 0
static var tree: SceneTree
var states: Dictionary[Control, bool] = {}

static var MENU_TRANSITION_TIME: float
static var lerpControl: Dictionary[Object, bool] = {}

static func smooth(x, antidegree: float = 1):
	var y = sin(x*PI/2.0)**(2/antidegree)
	return y

static func lerpAnimation(obj, property: String, from, to, time: float):
	var t: float = 0
	if obj.get(property) == to:
		return
	if obj in lerpControl.keys():
		lerpControl[obj] = false
		while obj in lerpControl.keys():
			await tree.process_frame
			
	lerpControl[obj] = true
	while t < time:
		if !lerpControl[obj]:
			break
		var x = from + (to - from)*smooth(t/time, 2)
		obj.set(property, x)
		print("lerping: ", x)
		t += lastDelta
		await tree.create_timer(lastDelta).timeout
	lerpControl.erase(obj)
	
func _ready() -> void:
	tree = get_tree()
	for menu in menus:
		states[menu] = false


func _process(delta: float) -> void:
	lastDelta = delta
	for menu in states.keys():
		if InputMap.has_action(menu.name) && Input.is_action_just_pressed(menu.name):
			panelLogic(menu)
	
	OverworldPlayer.INPUT_FLAGS["movement"] = !states[menus[0]]
	
	

func panelLogic(menu: Control):
	states[menu] = !states[menu]
	await call("_"+menu.name, menu, states[menu])

func setPanelLogic(menu: Control, forcedState: bool):
	states[menu] = forcedState
	await call("_"+menu.name, menu, states[menu])

func toggleMenu(_name: String):
	for menu in states.keys():
		if _name == menu.name:
			await panelLogic(menu)

func setMenu(_name: String, forcedState: bool):
	for menu in states.keys():
		if _name == menu.name:
			await setPanelLogic(menu, forcedState)

#methods
func _menu_panel(node: Control, state: bool) -> void:
	if state:
		await setMenu("DeckEditUI",false)
		await setMenu("InventoryUI",false)
		await lerpAnimation(node,"position", node.position, Vector2(1920-node.size.x, node.position.y), 0.5)
	else:
		await lerpAnimation(node,"position", node.position, Vector2(1920, node.position.y), 0.5)

func _DeckEditUI(node: Control, state: bool) -> void:
	if state:
		setMenu("menu_panel",false)
		node.initialize()
		await lerpAnimation(node,"position", node.position, Vector2(node.position.x, 0), 0.5)
	else:
		await lerpAnimation(node,"position", node.position, Vector2(node.position.x, -1080), 0.5)

func _InventoryUI(node: Control, state: bool) -> void:
	if state:
		setMenu("menu_panel",false)
		OverworldPlayer.singleton.toggleInventory(state)
	else:
		OverworldPlayer.singleton.toggleInventory(state)
