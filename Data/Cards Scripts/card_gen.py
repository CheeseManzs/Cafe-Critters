'''extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Unique
	description = "30% Defend, Empowered: Draw 1"
	name = "Affogato"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#idk what barrier is ngl but remember to apply empower to it
	var shieldGiven = ceil(0.3*attacker.getDefense())
	attacker.addShield(shieldGiven)
	#if empowered, draw 1 card
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attacker.drawCards(1)
	
	return shieldGiven

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	var shieldGiven = ceil(0.3*attacker.getDefense())
	return shieldGiven'''
import csv
import os.path

def gen_program(cost, prio, align, role, desc, name):
    filename = name.replace("&","")+".gd"
    make = not os.path.isfile(filename)
    filetext = f'''extends Card

func _init() -> void:
	cost = {cost}
	priority = {prio}
	alignment = ALIGNMENT.{align}
    role = "{role}"
	description = "{desc}"
	name = "{name}"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
'''
    if make:
        o = open(filename,'w')
        o.write(filetext)
        o.close()
        print("wrote to " + filename)

card_file = open("Legends of Coffeeland - Master List.csv")
cards = csv.reader(card_file, delimiter=',', quotechar='"')
for card in cards:
    "Code #,Card Name,God,Rarity,Class,Role,Cost,Card Description,WIP Status,Implemented"
    code = card[0]
    name = card[1]
    prio = 0
    align = card[2].split(" ")[0]
    role = card[5]
    cost = card[6]
    desc = card[7]
    if name == "Card Name":
        continue
    gen_program(cost, prio, align, role, desc, name)
    


