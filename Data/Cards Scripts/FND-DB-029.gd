extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Apply Fatigue 1 to opponent. If they're Fatigued, apply Fatigue 3 instead."
	name = "Cripple"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	if defender.hasStatus(Status.EFFECTS.FATIGUE):
		await giveStatus(defender, Status.EFFECTS.FATIGUE, 3)
	else:
		await giveStatus(defender, Status.EFFECTS.FATIGUE, 1)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	if defender.hasStatus(Status.EFFECTS.FATIGUE):
		return Status.new(Status.EFFECTS.FATIGUE, 3)
	else:
		return Status.new(Status.EFFECTS.FATIGUE, 1)
