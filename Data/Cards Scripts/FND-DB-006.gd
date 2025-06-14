extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Next turn start: Draw 2."
	name = "Stock Up"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	attacker.extraDraw = 2
	await BattleLog.log(attacker.getName() + " will draw 2 more cards next turn!")
