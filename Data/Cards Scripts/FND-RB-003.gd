extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Search your deck for any Omen card. Put it in the graveyard."
	name = "Raven Sighting"
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	var omenDeck = Zone.getTaggedCardsInArray(attacker.currentDeck.storedCards, "Omen")
	if len(omenDeck) > 0:
		var card = omenDeck[attacker.battleController.global_rng.randi_range(0, len(omenDeck) - 1)]
		attacker.currentDeck.storedCards.erase(card)
		attacker.battleController.addToGraveyard(card, attacker)
		BattleLog.singleton.log(card.name + " was sent to the graveyard!")
	else:
		BattleLog.singleton.log("No omen cards in the deck...")
		return
