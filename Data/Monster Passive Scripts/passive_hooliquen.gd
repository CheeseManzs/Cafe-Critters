extends PassiveAbility

func _init() -> void:
	name = "Sore Loser"
	desc = "Whenever Hooliquen discards a card with Attack > 100%, gain Priority 2."

func onDiscard(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	if card.calcDamage(mon, battle.getOpposingMon(mon.playerControlled)) > mon.getAttack():
		await EffectFlair.singleton._runFlair(mon.rawData.name,Color.DARK_RED)
		await battle.getOpposingMon(mon.playerControlled).addStatusCondition(Status.new(Status.EFFECTS.STRONGARM,1), true)
