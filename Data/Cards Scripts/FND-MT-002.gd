extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Token"
	description = "Token card. Draw 1."
	name = "Jetsam"
	power = 0



	
func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.drawCards(1)
	
		
