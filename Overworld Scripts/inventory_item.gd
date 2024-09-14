extends Control
@onready var spriteNode = $TextureRect
var referentObject: InventoryItem
var item
var quantity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initiate(itemRes: String, loadQuantity: int):
	item = load("res://Data/Items/" + itemRes + ".tres")
	print(item.name)
	quantity = loadQuantity
	$TextureRect.set_texture(item.sprite)
	item.sprite
	$TextureRect/Label.text = str(quantity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	pass # Replace with function body.
