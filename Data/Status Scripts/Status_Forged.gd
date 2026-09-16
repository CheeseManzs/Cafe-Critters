class_name Status_Forged
extends Status

func _init() -> void:
	effect = EFFECTS.FORGED
	isNumerable = true
	X = 1

func p_nameMini() -> String:
	return "FRG"

func p_nameFull() -> String:
	return "Forged"

func card_onApplied(card: Card):
	card.power += 0.05 * X
	card.shieldPower += 0.05 * X
	card.resetDescription()

func modifyCardDesc(card: Card) -> String:
	return card.description + " \nForged " + str(X) + " times."
	
func card_modifyHintRatio(statName: String) -> int:
	if statName == "ATK": return 5 * X
	if statName == "DEF": return 5 * X
	return 0
