extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "125% Defense. Gain Regen 5."
	name = "Rejuvenate"
	shieldPower = 1.25
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await giveStatus_noempower(attacker,Status.EFFECTS.REGEN, 5)



#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.REGEN, 5)
