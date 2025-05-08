extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Set your Attack to 0. Empower the next card played."
	name = "Press"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	await attacker.setAttack(0)
	await giveStatus_noempower(attacker,Status.EFFECTS.EMPOWER_PLAYED)
	return 0

func calcBonus(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 1

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.EMPOWER_PLAYED)
