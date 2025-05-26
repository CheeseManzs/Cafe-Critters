extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Gain (40% DEF) block. If this card is played with a modified cost, draw a card."
	name = "Cappucino"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
