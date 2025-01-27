extends Card

func _init() -> void:
	cost = 1
	priority = 2
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Roll two 6-sided die. (Number rolled x 5)% Defend."
	name = "Dice Defend"
	shieldPower = 0

func effect(attacker: BattleMonster, defender: BattleMonster):
	var sum = 0
	sum += await rollDice(attacker)
	sum += await rollDice(attacker)
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		sum += await rollDice(attacker)
	await attacker.battleController.get_tree().create_timer(1.0).timeout
	await giveShield(attacker,defender,0.01*sum*5,false)

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	return _calcShield(attacker,defender,0.07*5)
