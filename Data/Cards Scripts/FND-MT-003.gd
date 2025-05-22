extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Point"
	description = "Inflict 3 Riptide."
	name = "Riptide Rushdown"
	power = 0



	
func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.drawCards(1)
	await giveStatus(defender,Status.EFFECTS.RIPTIDE,3)
	
	
