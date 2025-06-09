extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Gain (20% DEF) block. If you block an Attack this action, gain 2 MP and your next Attack deals (20% ATK) more damage."
	name = "Step Back"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Uncommon
	shieldPower = 2

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await giveStatus(attacker, Status.EFFECTS.STEP_BACK)
	pass

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.STEP_BACK)
