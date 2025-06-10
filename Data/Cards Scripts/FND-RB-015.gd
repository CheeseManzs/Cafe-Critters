extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "If a Defence has been placed into your graveyard this turn, gain (120% DEF) block."
	name = "Spirit Barrier"
	tags = ['Defence']
	rarity = RARITY.Uncommon
	shieldPower = 1.2

func canBePlayed(user: BattleMonster):
	var defCards = Zone.getTaggedCardsInArray(user.addedToGraveyardThisTurn, "Defence")
	return len(defCards) > 0

func effect(attacker: BattleMonster, defender: BattleMonster):
	var defCards = Zone.getTaggedCardsInArray(attacker.addedToGraveyardThisTurn, "Defence")
	if len(defCards) > 0:
		await giveShield(attacker, defender)
