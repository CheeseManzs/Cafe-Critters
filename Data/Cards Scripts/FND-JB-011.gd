extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll 2 dice. Gain (8% DEF) block, multiplied by the roll value."
	name = "Dice Defend"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Common
	shieldPower = 0.08

func effect(attacker: BattleMonster, defender: BattleMonster):
	var roll = (await rollDice(attacker)) + (await rollDice(attacker))
	var totalShieldPower = shieldPower*roll
	await giveShield(attacker, defender, totalShieldPower)
