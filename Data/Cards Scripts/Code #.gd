extends Card

func _init() -> void:
	cost = Cost
	priority = Speed
	alignment = ALIGNMENT.God
	description = "Description"
	name = "Name"
	tags = ['Tags']
	rarity = RARITY.Rarity

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
