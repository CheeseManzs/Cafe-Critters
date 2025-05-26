extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (50% DEF) block."
	name = "Light Block"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Common
	shieldPower = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
