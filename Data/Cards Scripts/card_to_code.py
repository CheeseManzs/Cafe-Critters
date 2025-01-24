import csv
import os
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
    filename = name.replace("&","")+".gd"
    newfilename = code.replace("-","_")+".gd"
    if os.path.isfile(filename):
        print(filename,"->",newfilename)
        #os.rename(filename, newfilename)
        tresfile = '../Cards/'+name+".tres"
        if os.path.isfile(tresfile):
            o = open(tresfile)
            otext = o.read()
            scriptString = "res://Data/Cards Scripts/"+filename
            otext.replace(scriptString,scriptString.replace(filename,newfilename))
            print(scriptString,'\n',otext)
            o.close()
        else:
            print("found file but no tres:",filename)
