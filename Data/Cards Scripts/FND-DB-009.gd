extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Your next played card goes first."
	name = "Speed Up"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.PRIORITY, 1)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.PRIORITY, 1)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
