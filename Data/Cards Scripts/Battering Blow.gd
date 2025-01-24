extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "Your next attack gains +50% if your opponent is Defending. Strongarm. Gain 2 mp."
	name = "Battering Blow"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
