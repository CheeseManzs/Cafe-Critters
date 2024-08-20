extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "Gain 1 mp. Gain Barrier 5."
	name = "Affogato"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#idk what barrier is ngl but remember to apply empower to it
	var shieldGiven = ceil(0.3*attacker.defense)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		shieldGiven = ceil(shieldGiven*1.5)
	attacker.addShield(shieldGiven)
	var mpGiven = 1
	#add mp
	attacker.addMP(mpGiven)
	return mpGiven

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shieldGiven = 5
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		shieldGiven = ceil(shieldGiven*1.5)
	return shieldGiven
