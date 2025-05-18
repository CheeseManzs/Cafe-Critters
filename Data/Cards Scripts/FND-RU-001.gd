extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Rev"
	description = "As an additional cost to play this card, shuffle an Omen card back into it's respective Fae's deck. Prevent the next instance of damage taken this turn."
	name = "Dodge Roll"

func effect(attacker: BattleMonster, defender: BattleMonster):
	var omenCards = getOmenCards(attacker.battleController)
	if len(omenCards) <= 0:
		BattleLog.singleton.log("No omen cards to retrieve...")
		await attacker.battleController.get_tree().create_timer(1.0).timeout
		return
	var omenCard: Card = BattleController.syncedRandInArray(omenCards)
	attacker.battleController.graveyard.erase(omenCard)
	attacker.currentDeck.storedCards.push_back(omenCard)
	BattleLog.singleton.log(attacker.rawData.name + " retrieved " + omenCard.name + " from the Graveyard!")
	await attacker.battleController.get_tree().create_timer(1.0).timeout
	await giveStatus(attacker, Status.EFFECTS.NULLIFY_DAMAGE, 0, 0, true, false)
	pass

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	var omenCards = getOmenCards(attacker.battleController)
	if len(omenCards) <= 0:
		return null
	else:
		return Status.new(Status.EFFECTS.NULLIFY_DAMAGE)
