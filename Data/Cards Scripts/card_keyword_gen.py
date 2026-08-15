import csv
import os

file_path = __file__
directory = os.path.dirname(file_path)

script_path = directory+"/../../Battle Scripts/keyword.gd"
def get_script_template(keywords, keyword_dict):

    desc = ""
    keyword_drop = ""
    for keyword in keywords:
        keyword_drop += f'"{keyword}",\n'
        desc += f'"{keyword}": "{keyword_dict[keyword]}",\n'
    return f'''class_name Keyword
extends Node

static var keywords = [
{keyword_drop}]

static var keywordDescriptions = {"{"}
{desc}{"}"}

static func getDescription(keywordString) -> String:
	return keywordDescriptions[keywordString]
'''

keyword_file = open("card_keywords.csv")
keywords = csv.reader(keyword_file, delimiter=',', quotechar='"')

_kw = []
_kwdict = {}
for keyword in keywords:
    keys = "Name,Desc".split(",")
    keyword_obj = {}
    kw = keyword[0].replace(" X","").replace(" +X","")
    _kw.append(kw)
    _kwdict[kw] = keyword[1]

genned = get_script_template(_kw, _kwdict)

f = open(script_path,'w')
f.write(genned)
print(genned)
print("Done writing...")
    
    


