class_name ZDialogFile
extends Resource

@export var fileName: String

static func classAlias(classPath: String):
	var aliasDict = {
		"AIPersonality": "res://Battle Scripts/ai_personality.gd",
		"Gift": "res://Data/Source Code/gift_types.gd"
	}
	if classPath in aliasDict:
		var aliasName = aliasDict[classPath]
		return aliasName
	else:
		return classPath


static func getZText(line: String, lineArray: Array[String], index: int) -> ZText:
	var indents = line.count("\t")
	line = line.dedent()
	var textData = line
	var speakerSprite = null
	var speakerName = ""
	var conds: Array[String] = []
	var condLines: Array[ZDialog] = []
	var endEffects = []
	var metadata = []
	
	if line.contains(": "):
		#split line between speaker data and text
		var data = line.split(": ",true,1)
		textData = data[1]
		var speakerData = data[0]
		#get speaker
		speakerName = speakerData
		if speakerName.contains(", "):
			speakerData = speakerData.split(", ")
			speakerName = speakerData[0]
			if speakerData[1] != "none":
				speakerSprite = getTexture(speakerData[1])
		else:
			speakerSprite = getTexture(speakerData)
	
	if textData.contains(" {"):
		var condData = textData.split(" {")
		textData = condData[0]
		var condArr = condData[1].replace("}","").split(", ")
		var condLineArrs = []
		
		for con in condArr:
			conds.push_back(con)
			condLineArrs.push_back([])
		
		var lastPrefix = ""
		for indexOffset in (len(lineArray) - index - 1):
			var currentIndex = index + indexOffset + 1
			var rawLine: String = lineArray[currentIndex]
			var currentIndents = rawLine.count("\t")
			var currentLine: String = lineArray[currentIndex].strip_edges()
			if currentLine.contains("[IGNORE]"):
				continue
			if currentIndents == indents:
				lineArray[currentIndex] = currentLine + " [IGNORE]"
				break
			if currentLine.begins_with("{") && currentLine.ends_with("}") && currentIndents == indents+1:
				var strippedLine = currentLine.replace("{","").replace("}","")
				lastPrefix = strippedLine
				lineArray[currentIndex] = currentLine + " [IGNORE]"
				continue
			elif lastPrefix != "":
				condLineArrs[conds.find(lastPrefix)].push_back(rawLine)
				lineArray[currentIndex] = currentLine + " [IGNORE]"
			
		
		for c in condLineArrs:
			var cList: Array[String]
			cList.assign(c)
			condLines.push_back(getZDialog(cList))
	else:
		for event in ZText.EFFECTS.keys():
			var splitString = " ("+event+")" 
			if textData.contains(splitString):
				textData = textData.replace(splitString, "")
				var eventData = []
				for indexOffset in (len(lineArray) - index - 1):
					var currentIndex = index + indexOffset + 1
					var rawLine: String = lineArray[currentIndex]
					var currentIndents = rawLine.count("\t")
					var currentLine: String = lineArray[currentIndex].strip_edges()
					if currentLine.contains("[IGNORE]"):
						continue
					if currentIndents == indents:
						lineArray[currentIndex] = currentLine + " [IGNORE]"
						break
					if currentLine.begins_with(event+": "):
						var metadataString = currentLine.replace(event+": ", "")
						var md = metadataString
						#parse metadata
						if md.contains("("):
							var splitIndex = md.find("(")
							var mdData = [md.substr(0, splitIndex), md.substr(splitIndex+1, len(md) - 1)]
							var className = mdData[0]
							var classData = mdData[1].strip_edges().trim_suffix(")")
							var classObjects = []
							if len(classData) > 0:
								for obj in classData.split(", "):
									var expr = Expression.new()
									expr.parse(obj)
									var res = expr.execute()
									classObjects.push_back(res)
							var cName = classAlias(className)
							var loadedScript = load(classAlias(className))
							var inst = loadedScript.callv("new",classObjects)
							eventData.push_back(inst)
						else:
							var expr = Expression.new()
							expr.parse(md)
							var res = expr.execute()
							eventData.push_back(res)
						lineArray[currentIndex] = currentLine + " [IGNORE]"
				#get metadata
				endEffects.push_back(ZText.EFFECTS[event])
				metadata.push_back(eventData)
		pass		
				
					
			
	var text: ZText
	if len(conds) == 0:
		text = ZText.new(textData, speakerName, speakerSprite)
	else:
		text = ZText.new(textData, speakerName, speakerSprite, conds, condLines)
	#set metadata
	if len(endEffects) != 0:
		text.endEffects.assign(endEffects)
		text.endMetadata = metadata
		text.startEffects = []
		text.startMetadata = []
	return text

static func getTexture(spriteFile: String) -> Texture:
	return ResourceLoader.load("res://Graphics/Overworld/"+spriteFile+".png")

func toDialog() -> ZDialog:
	return getZDialogFromFile(fileName)

static func getZDialogFromFile(fName: String) -> ZDialog:
	var textFile = FileAccess.open("res://Data/Text/"+fName+".zd",FileAccess.READ)
	var rawText = textFile.get_as_text()
	return getZDialogFromString(rawText)

static func getZDialogFromString(lines: String) -> ZDialog:
	var lineArr: Array[String]
	lineArr.assign(lines.split("\n"))
	return getZDialog(lineArr)
	
static func getZDialog(lineArr: Array[String]) -> ZDialog:
	var dialog = ZDialog.new()
	dialog.texts.assign([])
	var i = -1
	for line in lineArr:
		i += 1
		if line.contains("[IGNORE]"):
			continue
		dialog.texts.push_back(getZText(line, lineArr, i))
	return dialog
