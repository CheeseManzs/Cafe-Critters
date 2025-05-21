extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Point"
	description = "Mill 20."
	name = "Mill 20"
	power = 0



	
func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.millCards(20)
	
		
