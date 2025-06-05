extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Clear all enemy positive effects. Apply Fatigue 1 to the opponent."
	name = "Rinse"
	tags = ['Utility']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	for status in defender.statusConditions:
		if status.isPositive():
			status.effectDone = true
	
	BattleLog.log(defender.getName() + " lost their positive status effects!")
	await giveStatus(defender, Status.EFFECTS.FATIGUE, 1)
	pass

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.FATIGUE, 1)
