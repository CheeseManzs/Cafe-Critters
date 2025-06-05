extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Apply Fatigue 1 to opponent."
	name = "Hinder"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(defender, Status.EFFECTS.FATIGUE, 1)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.FATIGUE, 1)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
