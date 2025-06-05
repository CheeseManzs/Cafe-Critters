extends Card

func _init() -> void:
	cost = 3
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (150% DEF) block. Gain Regen 15."
	name = "Rejuvenate"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Rare
	shieldPower = 1.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await giveStatus(attacker, Status.EFFECTS.REGEN, 15)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.REGEN, 15)
#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null
