extends PassiveAbility

func _init() -> void:
	name = "Snake's Jackpot"
	desc = "Snake Eyes treats 1s rolled on any die as the highest number instead."

func diceTransform(mon: BattleMonster, battle: BattleController, diceNumber: int, maxNumber: int = 6) -> int:
	var x: int = diceNumber
	if x == 1:
		x = maxNumber
	return x
