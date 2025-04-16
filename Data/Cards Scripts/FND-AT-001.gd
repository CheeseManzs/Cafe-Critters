extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Token
	description = "Token card. Does nothing."
	name = "Scrap Token"
	power = 0
	tags = ["Scrap"]



	
func effect(attacker: BattleMonster, defender: BattleMonster):
	BattleLog.log(attacker.rawData.name + " throws... scrap?")
