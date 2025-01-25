extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "75% Attack. If Tagged, 150% Attack instead."
	name = "Last Chance"
	power = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	#calc attack power
	if attacker.hasStatus(Status.EFFECTS.TAGGED):
		await dealDamage(attacker, defender, power)
	else:
		await dealDamage(attacker, defender, power*2)

#checks what status will be removed from the user
func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var dmg = attacker.getAttack()*0.75
	if attacker.hasStatus(Status.EFFECTS.TAGGED):
		dmg = attacker.getAttack()*1.50
	return dmg
