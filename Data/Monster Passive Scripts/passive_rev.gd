extends PassiveAbility

func _init() -> void:
	name = "Revenerator"
	desc = "N/A"

#runs when a monster attacks
func onConditonal(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	await EffectFlair.singleton._runFlair(mon.rawData.name,Color.REBECCA_PURPLE)
	var omenCards = Zone.getTaggedCardsInArray(mon.currentDeck.storedCards, "Omen")
	if len(omenCards) <= 0:
		return
	var omenCard: Card = BattleController.syncedRandInArray(omenCards)
	mon.currentDeck.storedCards.erase(omenCard)
	mon.battleController.graveyard.push_back(omenCard)
	return

func onSwapOut(mon: BattleMonster, battle: BattleController) -> void:
	var missingHP: int = mon.maxHP - mon.health
	if missingHP/2 > 0:
		await EffectFlair.singleton._runFlair(mon.rawData.name,Color.REBECCA_PURPLE)
		await mon.addHP(missingHP/2)
	return
