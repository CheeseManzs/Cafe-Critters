extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Create a copy in hand of the last skill played by any fae."
	name = "Mashup"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
