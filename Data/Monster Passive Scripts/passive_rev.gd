extends PassiveAbility

func _init() -> void:
	name = "Revenerator"
	desc = "If a card played by Rev has its conditional effect trigger, search your deck for any Omen card. Put it in the graveyard. Rev heals 50% of its missing HP on switch-out."

#runs when a monster attacks
func onConditonal(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	await createFlair(mon)
	var omenCards = Zone.getTaggedCardsInArray(mon.currentDeck.storedCards, "Omen")
	if len(omenCards) <= 0:
		return
	var omenCard: Card = BattleController.syncedRandInArray(omenCards)
	mon.currentDeck.storedCards.erase(omenCard)
	await mon.battleController.addToGraveyard(omenCard, mon)
	return

func onSwapOut(mon: BattleMonster, battle: BattleController) -> void:
	var missingHP: int = mon.maxHP - mon.health
	if missingHP/2 > 0 && !mon.isKO():
		await createFlair(mon)
		await mon.addHP(missingHP/2)
	return
