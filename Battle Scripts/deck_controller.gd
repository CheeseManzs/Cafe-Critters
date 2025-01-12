class_name DeckController
extends Control
@export var cardBackPrefab: PackedScene

var cardsInDeck: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func addCard():
	var back: Node = cardBackPrefab.instantiate()
	back.scale = back.scale*0.8
	self.add_child(back)
	back.targetPos = Vector2(0, 0)
	await get_tree().create_timer(0.2).timeout

func removeCard():
	var back: CardBack = null
	for i in range(get_child_count()):
		back = get_child(get_child_count() - i - 1)
		if !back.removing:
			break
	if back != null:
		await back.destroy()

func updateDeckDisplay(count: int) -> void:
	var delta = count - cardsInDeck
	cardsInDeck = count
	if abs(delta) < 10:
		if delta > 0:
			for cardindex in range(delta):
				await addCard()
		if delta < 0:
			for cardindex in range(-delta):
				await removeCard()
	else:
		if delta > 0:
			for cardindex in range(delta):
				addCard()
		if delta < 0:
			for cardindex in range(-delta):
				removeCard()
		
