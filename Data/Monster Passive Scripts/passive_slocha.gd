extends PassiveAbility

func _init() -> void:
	name = "Refreshing Tea"
	desc = "N/A"

func beforeAttack(mon: BattleMonster, battle: BattleController, card: Card) -> void:
	print(card.statusConditions)
	if card.statusConditions.has(Status.EFFECTS.EMPOWER):
		await EffectFlair.singleton._runFlair(mon.rawData.name,Color.SADDLE_BROWN)
		mon.addStatusCondition(Status.new(Status.EFFECTS.HASTE, 1), true)
		battle.getOpposingMon(mon.playerControlled).addStatusCondition(Status.new(Status.EFFECTS.SLOW, 1), true)
	return
