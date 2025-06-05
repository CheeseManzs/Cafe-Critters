extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain Attack Up 1."
	name = "Attack Up"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.ATTACK_UP, 1)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.ATTACK_UP, 1)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
