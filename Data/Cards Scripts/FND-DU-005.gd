extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "30% Defend, Empowered: Draw 1"
	name = "Affogato"
	shieldPower = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	#idk what barrier is ngl but remember to apply empower to it
	await giveShield(attacker, defender, shieldPower, false)
	#if empowered, draw 1 card
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attacker.drawCards(1)
	
	return

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shieldGiven = ceil(0.3*attacker.getDefense())
	return shieldGiven
