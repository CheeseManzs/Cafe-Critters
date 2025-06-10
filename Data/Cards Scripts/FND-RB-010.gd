extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Gain (30% DEF) block for each card placed into a graveyard this turn."
	name = "Due Dilligence"
	tags = ['Defence']
	rarity = RARITY.Common
	shieldPower = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	var fullPower = shieldPower*(attacker.battleController.playerCardsAddedToGraveyardThisTurn + attacker.battleController.enemyCardsAddedToGraveyardThisTurn)
	await giveShield(attacker, defender, fullPower)

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	var fullPower = shieldPower*(attacker.battleController.playerCardsAddedToGraveyardThisTurn + attacker.battleController.enemyCardsAddedToGraveyardThisTurn)
	return _calcShield(attacker, defender, fullPower)
