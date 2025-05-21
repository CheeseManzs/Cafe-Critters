extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Token"
	description = "Token card. Draw 1. Salvage: Draw 1, gain 1 mp."
	name = "Flotsam"
	power = 0



	
func effect(attacker: BattleMonster, defender: BattleMonster):
	attacker.drawCards(2)
	
	if salvaged:
		await attacker.addMP(1)
		
