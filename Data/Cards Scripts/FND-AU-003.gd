extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "As an additional cost to play this card, discard any amount of token cards. Gain 1 Heat per card discarded. Gain Regen equal to the amount of Heat you have. Gain 1 mp."
	name = "Treatz"
	selfTarget = true

func drawReq(x: Card):
	return x.role is int && x.role == "Token"

func effect(attacker: BattleMonster, defender: BattleMonster):
	var cards = await attacker.battleController.chooseCards(99,attacker.playerControlled,true,drawReq)
	if len(cards) > 0:
		for card in cards:
			await attacker.discardCard(card, true, false)
		await attacker.addHeat(len(cards))
		await giveStatus(attacker,Status.EFFECTS.REGEN,attacker.getHeat())
	else:
		BattleLog.log("No token cards to discard...")
	pass
