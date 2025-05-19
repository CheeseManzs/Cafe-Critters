extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "As an additional cost to play this card, discard a token card. Inflict 8 direct damage to the opponent Fae. Inflict 2 Burn"
	name = "Molten Bubble"

func effect(attacker: BattleMonster, defender: BattleMonster):
	var dis = await attacker.discardRandomTokenCard()
	power = 0
	if dis != null:
		power = 1
		await defender.trueDamage(8,attacker)
		await giveStatus(defender,Status.EFFECTS.BURN,2)
	else:
		BattleLog.log("No token card to discard...")

func canBePlayed(user: BattleMonster):
	var omenCards = user.getRoleCardsInHand("Token")
	return (user.gravyardSize() >= 1)


func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	if len(Zone.getRoleCardsInArray(attacker.currentHand.storedCards,"Token")) > 0:
		return 8
	else:
		return 0
