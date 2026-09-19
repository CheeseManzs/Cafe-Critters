class_name Status_Atk_Up
extends Status

func _init(stacks: int) -> void:
	effect = EFFECTS.ATK_UP
	isNumerable = true
	isPositive = true
	endsOnSwitch = true
	X = stacks

func p_atkBoost(user: BattleMonster = null) -> float:
	return 1 + 0.1 * X

func p_nameMini() -> String:
	return "ATK+"

func p_nameFull() -> String:
	return "ATK+"
