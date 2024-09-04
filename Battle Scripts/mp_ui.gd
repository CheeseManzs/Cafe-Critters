extends VBoxContainer
@export var battleController: BattleController
@export var mpFill: TextureProgressBar
@export var mpText: RichTextLabel
@export var player = false
var oldMP = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func textPop() -> void:
	scale = Vector2(1.7, 1.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	scale = lerp(scale, Vector2(1, 1),delta*16)
	mpText.text = "[center]"+str(battleController.playerMP)+"[/center]"
	var dt: float = battleController.playerMP - mpFill.value
	var normalDT: float = dt/abs(dt)
	mpFill.value += normalDT*delta

	if abs(mpFill.value - battleController.playerMP) < delta*6:
		mpFill.value = battleController.playerMP
	else:
		mpFill.value += normalDT*delta*3
	
	if oldMP != battleController.playerMP:
		oldMP = battleController.playerMP
		textPop()
