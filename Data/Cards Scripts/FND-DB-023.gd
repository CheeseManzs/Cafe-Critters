extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Clear all user negative effects. Gain Regen 3."
	name = "Soothing Song"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	for status in attacker.statusConditions:
		if !status.isPositive():
			status.effectDone = true
	
	BattleLog.log(defender.getName() + " cleared all their negative status effects!")
	
	await giveStatus(attacker, Status.EFFECTS.REGEN, 3)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.REGEN, 3)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
