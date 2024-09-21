extends Control
@onready var spriteNode = $TextureRect
var referentObject: InventoryItem
var refItem
var quantity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initiate(monsterRes: String, loadQuantity: int):
	# gets the appropriate inventory item, loads its sprite, name, description, etc
	refItem = load("res://Data/Monsters/" + monsterRes + ".tres")
	#print(refItem.name)
	quantity = loadQuantity
	$TextureRect.set_texture(refItem.sprite)
	#item.sprite
	$TextureRect/Label.text = str(quantity)
	$Tooltip/ItemName.text = "[center]" + refItem.name + "[/center]"
	$Tooltip/ItemDesc.text = refItem.desc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Tooltip.position = get_local_mouse_position()
	pass


func _on_texture_rect_mouse_entered() -> void:
	$Tooltip.visible = true
	pass # Replace with function body.


func _on_texture_rect_mouse_exited() -> void:
	$Tooltip.visible = false
	pass # Replace with function body.
