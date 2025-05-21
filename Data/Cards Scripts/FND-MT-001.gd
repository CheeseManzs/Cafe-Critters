extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Token"
	description = "Token card. Draw 1. Salvage: Draw 1, gain 1 mp."
	name = "Flotsam"
	power = 0



	
func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.drawCards(1)
	
	if salvaged:
		await attacker.addMP(1)
		
