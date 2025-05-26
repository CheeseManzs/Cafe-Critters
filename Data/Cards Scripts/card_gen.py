import csv
import os.path

def gen_program(card):
    filename = card["Code #"]+".gd"
    make = not os.path.isfile(filename)
    filetext = f'''extends Card

func _init() -> void:
\tcost = {card["Cost"]}
\tpriority = {card["Priority"]}
\talignment = ALIGNMENT.{card["God"]}
\trole = "{card["Role"]}"
\tdescription = "{card["Simplified Description"]}"
\tname = "{card["Name"]}"
\ttags = {card["Tags"]}
\trarity = RARITY.{card["Rarity"]}

func effect(attacker: BattleMonster, defender: BattleMonster):
\tpass
'''
    if make:
        o = open(filename,'w')
        o.write(filetext)
        o.close()
        print("wrote to " + filename)

card_file = open("card_list.csv")
cards = csv.reader(card_file, delimiter=',', quotechar='"')
for card in cards:
    keys = "Code #,Name,God,Rarity,Tags,Role,Cost,Priority,Simplified Description,Card Description,WIP Status,Implemented".split(",")
    card_obj = {}
    index = 0
    for key in keys:
        card_obj[key] = card[index]
        index += 1

    tag_list = []
    for tag in card_obj["Tags"].split(","):
        tag_list.append(tag)

    card_obj["Tags"] = str(tag_list)
    
    if card_obj["Simplified Description"] != "" and card_obj["WIP Status"] == "V4 Updated" and card_obj["Code #"] != "":
        print("---")
        print(card_obj)
        gen_program(card_obj)
    
    if card_obj["Name"] == "Card Name":
        continue
    
    


