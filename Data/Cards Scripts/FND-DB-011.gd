extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Deal (50% ATK) damage. Gain (50% DEF) block."
	name = "Shield Slap"
	tags = ['Attack']
	rarity = RARITY.Common
	shieldPower = 0.5
	power = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await dealDamage(attacker, defender)
