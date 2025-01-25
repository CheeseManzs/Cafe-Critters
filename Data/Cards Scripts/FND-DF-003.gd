extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Forward"
	description = "When you play this card, you can no longer play other cards for the rest of the turn. 100% Attack"
	name = "Last Stand"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = attacker.getAttack()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		dmg = ceil(dmg*1.5)
	await defender.receiveDamage(dmg, attacker)
	attacker.addStatusCondition(Status.new(Status.EFFECTS.CANT_PLAY))
	return dmg

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = attacker.getAttack()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		dmg = ceil(dmg*1.5)
	return dmg

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.CANT_PLAY)
