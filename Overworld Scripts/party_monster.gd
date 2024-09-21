extends Control
var referentObject: Monster
var refMonster
var quantity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initiate(monster: Monster):
	# gets the appropriate monster, stores it, and loads its sprite.
	if monster != null:
		refMonster = monster
		$Panel/TextureRect.texture = refMonster.sprite
		
	else:
		refMonster = null
		$Panel/TextureRect.texture = null
		
	


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
