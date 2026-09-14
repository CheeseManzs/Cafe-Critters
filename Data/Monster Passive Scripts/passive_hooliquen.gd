extends PassiveAbility

func _init() -> void:
	name = "Sore Loser"
	desc = "When one or more cards enter your graveyard and they were not played from hand, deal (ATK 10%) damage."



func onCardEntersGraveyard(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	if card not in mon.playedCardCurrentTurnHistory:
		await createFlair(mon)
		var victim = battle.getOpposingMon(mon.playerControlled)
		await Card._dealDamage(mon, victim, 0.1)
