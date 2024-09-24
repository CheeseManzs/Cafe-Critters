extends Control
signal onClick
#var referentObject: Monster
var refMonster
var hovered = false
var quantity = 0
@export var id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel.mouse_entered.connect(_on_mouse_entered)
	$Panel.mouse_exited.connect(_on_mouse_exited)
	pass # Replace with function body.

func initiate(monster: Monster):
	# gets the appropriate monster, stores it, and loads its sprite.
	if monster != null:
		refMonster = monster
		print(refMonster.name)
		$Panel/TextureRect.texture = refMonster.sprite
		
	else:
		refMonster = null
		$Panel/TextureRect.texture = null
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Primary") and hovered == true:
		onClick.emit()
	#$Tooltip.position = get_local_mouse_position()
	pass


func _on_mouse_entered() -> void:
	print("wow")
	hovered = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	hovered = false
	pass # Replace with function body.
