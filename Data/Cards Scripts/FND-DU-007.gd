extends Card

func _init() -> void:
	cost = 1
	priority = -1
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Switch to another fae. Gain Focus 2."
	name = "Coffee Break"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.promptSwitch()
	await giveStatus(attacker.getActiveTeammate(), Status.EFFECTS.FOCUS, 2)
	
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.FOCUS, 2)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
