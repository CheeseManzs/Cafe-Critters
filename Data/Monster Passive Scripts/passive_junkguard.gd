extends MachineAbility

func _init() -> void:
	name = "Scrap Engine"
	desc = "Machine. Junkguard consumes all scrap in hand for a free switch-in."
#ability events:

func switchCostModifier_shelved(mon: BattleMonster, battle: BattleController, activeMon: BattleMonster, currentCost: int) -> int:
	var scrapInHand = activeMon.currentHand.getTaggedCardsInArray(activeMon.currentHand.storedCards, "Scrap")
	var hasScrap = (len(scrapInHand) > 0)
	
	if hasScrap:
		return -currentCost
	else:
		return 0

func onSwapIn_beforeSwap(newMon: BattleMonster, oldMon: BattleMonster, battle: BattleController) -> void:
	var scraps: Array[Card]
	scraps.assign(oldMon.currentHand.getTaggedCardsInArray(oldMon.currentHand.storedCards, "Scrap"))
	if len(scraps) == 0:
		return
	await createFlair(newMon)
	await oldMon.raiseAnimation()
	var cardCount = len(scraps)
	for scrap in scraps:
		await oldMon.quick_discardAnimation(scrap)
		await oldMon.getPassive().onDiscard(oldMon,battle,scrap)
	await oldMon.lowerAnimation()
	
	await oldMon.currentHand.removeCards(scraps)
