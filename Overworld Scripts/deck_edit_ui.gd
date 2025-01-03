extends Control
@export var storedCards: CardStorage = CardStorage.new()
@export var monDeck: CardStorage = CardStorage.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rebuildCards(): 
	for i in range(storedCards.itemNames.size()):
		for j in range(storedCards.itemNames[i].size()):
			# does the copy operation.
			# first creates the display node and loads its properties.
			var temp = storedCards.instantiate()
			temp.initiate(storedCards.cardNames[i][j], storedCards.cardData[i][j][1])
