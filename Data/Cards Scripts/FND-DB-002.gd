extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (100% DEF) block."
	name = "Block"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Common
	shieldPower = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
