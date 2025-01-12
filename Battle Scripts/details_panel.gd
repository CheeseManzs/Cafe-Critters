class_name DetailsPanel
extends Panel

@export var titleLabel: RichTextLabel
@export var canvasContainer: ControlChart
@export var cardDiplay: PackedScene
@export var displayContainer: VBoxContainer
var targetPos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetPos = Vector2(position.x,-503)
	pass # Replace with function body.

func setup(battleMonster: BattleMonster):
	titleLabel.text = "[center]"+battleMonster.rawData.name+"[/center]"
	canvasContainer.data = [
		battleMonster.getAttack(),
		battleMonster.getDefense(),
		battleMonster.maxHP
	]
	canvasContainer.dataLabels = [
		"ATK",
		"DEF",
		"HP"
	]
	
	
	for child in displayContainer.get_children():
		child.queue_free()
	
	for card in battleMonster.rawData.deck.storedCards:
		var newDisplay: RichTextLabel = cardDiplay.instantiate()
		displayContainer.add_child(newDisplay)
		newDisplay.text = card.name
	
	await get_tree().create_timer(0.01).timeout
	canvasContainer.reset()
	targetPos = Vector2(position.x,-3)


func hidePanel():
	targetPos = Vector2(position.x,-size.y - 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position,targetPos,delta*8)
	
	pass
	
