extends Button

@export var choiceID: int
@export var controller: BattleController
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func sendChoice():
	controller.onHand(choiceID)
	controller.emitGUISignal()

func setTextColor(col: Color):
	set("theme_override_colors/font_color",col)
