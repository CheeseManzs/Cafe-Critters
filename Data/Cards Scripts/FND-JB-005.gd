extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "If one of this fae's Attacks were fully blocked this turn, deal (25% ATK) damage."
	name = "Crashout"
	tags = ['Attack']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.CRASHOUT)
	pass

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.CRASHOUT)
