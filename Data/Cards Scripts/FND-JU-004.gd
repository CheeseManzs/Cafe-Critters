extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "Your next attack gains +25%. Strongarm. Gain 1 mp."
	name = "You're In For It Now"

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.addAttackBonus(0.25, true)
	await giveStatus(defender,Status.EFFECTS.STRONGARM, 1)
	await attacker.addMP(1)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.STRONGARM, 1)
