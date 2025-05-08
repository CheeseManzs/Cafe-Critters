extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Take damage equal to your Attack. Empower the next card played."
	name = "Roast"
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg: int = attacker.getAttack()
	await attacker.receiveDamage(dmg, attacker)
	await giveStatus_noempower(attacker,Status.EFFECTS.EMPOWER_PLAYED)
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.EMPOWER_PLAYED)
