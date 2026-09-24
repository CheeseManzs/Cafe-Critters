class_name Status_Stack_Your_Chips
extends Status

func _init() -> void:
	effect = EFFECTS.BURNOUT
	isNumerable = true
	X = 1
	endsOnTurn = true
	isPositive = true

func p_nameMini() -> String:
	return "SYC"

func p_nameFull() -> String:
	return "Stack Your Chips"

func onCardDiscarded(user: BattleMonster, card: Card):
	await card.dealDamage(user, user.getActiveEnemy(), 0.1)
	pass
