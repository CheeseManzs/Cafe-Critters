extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Haatea"
	description = "Whenever your opponent plays a card this turn, gain Regen 1. "
	name = "Boil"

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker,Status.EFFECTS.BOIL)
	pass

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.BOIL)
