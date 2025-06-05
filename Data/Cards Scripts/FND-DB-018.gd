extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain Regen 3. Gain 1 MP."
	name = "Prime"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.REGEN, 3)
	await attacker.addMP(1)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.REGEN, 3)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
