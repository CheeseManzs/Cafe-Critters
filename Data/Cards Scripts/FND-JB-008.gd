extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Gain (70% DEF) block. If your opponent Attacks this action, deal (70% ATK) damage."
	name = "Better Not"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Common
	shieldPower = 0.7

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	attacker.parryPower = 0.7
