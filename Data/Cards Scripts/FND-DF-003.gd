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
	await defender.receiveDamage(dmg, attacker)
	attacker.addStatusCondition(Status.new(Status.EFFECTS.CANT_PLAY))
	return dmg

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	return attacker.getAttack()
