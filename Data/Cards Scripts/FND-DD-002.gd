extends Card

func _init() -> void:
	cost = 2
	priority = 3
	alignment = ALIGNMENT.Default
	description = "Gain (100% DEF) block."
	name = "Block"
	tags = ['Defence']
	rarity = RARITY.Common
	shieldPower = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
