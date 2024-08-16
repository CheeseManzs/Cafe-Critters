extends Resource

@export var id: int
@export var name: String
@export var sprite: Texture
@export var deck: Zone
@export var startingCardPool: Zone
@export var statHealth: int
@export var statDefense: int
@export var statAttack: int

func _init(p_id = 0, p_name = "null", p_sprite = null, p_deck = null):
	id = p_id
	name = p_name
	sprite = p_sprite
	deck = p_deck
