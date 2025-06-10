extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Gain (39% DEF) block."
	name = "Ominous Vision"
	tags = ['Defence', 'Self-Target', 'Omen']
	rarity = RARITY.Common
	shieldPower = 0.39

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await applyOmen(attacker, defender)
