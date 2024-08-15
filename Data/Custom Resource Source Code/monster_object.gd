extends Resource

@export var id: int
@export var name: String
@export var sprite: Texture

func _init(p_id = 0, p_name = "null", p_sprite = null):
	id = p_id
	name = p_name
	sprite = p_sprite
