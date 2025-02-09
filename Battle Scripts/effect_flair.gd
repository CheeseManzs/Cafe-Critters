class_name EffectFlair
extends Control

static var singleton: EffectFlair
var battleController: BattleController = null
@export var label: RichTextLabel
@export var panelBG: Panel

var lastDelta: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self
	pass # Replace with function body.

func easeInOut(x):
	return -(cos(PI * x) - 1.0) / 2.0

func easeOut(x, power = 3):
	return 1 - pow(1 - x, power);

#runs flair animation
func _runFlair(title: String, col: Color = Color(239/255.0, 109/255.0, 89/255.0, 1)) -> void:
	label.text = "[center][shake level=15 rate=100][b]"+title+"[/b][/shake][/center]"
	var styleBox: StyleBoxFlat = panelBG.get_theme_stylebox("panel")
	styleBox.bg_color = col
	var t = 0
	var maxTime: float = 0.2
	size = Vector2(size.x, 0)
	
	battleController.playSound(battleController.flairSound)
	
	while t < maxTime:
		var x = t/maxTime
		var y = 100*easeOut(x, 3)
		size = Vector2(size.x, y)
		position = Vector2(0,1080/2 - size.y/2)
		t += lastDelta
		await get_tree().create_timer(lastDelta).timeout
	
	
	
	await get_tree().create_timer(1.0).timeout
	var t2 = 0
	
	while t2 < maxTime:
		var x = t2/maxTime
		var y = 100*easeInOut(1 - x)
		size = Vector2(size.x, y)
		position = Vector2(0,1080/2 - size.y/2)
		t2 += lastDelta
		await get_tree().create_timer(lastDelta).timeout
	
	
	size = Vector2(size.x, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = Vector2(0,1080/2 - size.y/2)
	lastDelta = delta
	pass
