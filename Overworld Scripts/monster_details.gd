extends Control
var refMonster

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func initiate(monster: Monster):
	refMonster = monster
	$TexturePanel/TextureRect.texture = monster.sprite
	$BodyPanel/DexEntryLabel.text = monster.dexEntry
	$BodyPanel/LevelPanel/LevelLabel.text = (monster.level + 1)
	$BodyPanel/StatLabel.text = "HP: " + monster.getHealth() + "\nATK: " + monster.getAttack() + "\nDEF: " + monster.getDefense()
	$BodyPanel/NamePanel/Label.text = monster.name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
