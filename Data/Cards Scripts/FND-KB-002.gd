extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Gain (30% DEF) block. Draw 1."
	name = "Note of Harmony"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Common
	shieldPower = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await attacker.drawCards(1)
