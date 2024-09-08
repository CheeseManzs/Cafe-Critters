class_name ZText
extends Resource

@export var text: String
@export var speakerName: String
@export var speakerSprite: Texture
@export var conditionalNames: Array[String]
@export var conditionalLines: Array[Resource]
@export var startScript: Script
@export var endScript: Script
var emptyLines: Array[Resource] = []
var emptyNames: Array[String] = []

func _init(p_text = "", p_speakerName = "", p_speakerSprite = null, c_names = emptyNames, 
		c_lines = emptyLines, p_SS = null, p_ES = null):
	text = p_text
	speakerName = p_speakerName
	speakerSprite = p_speakerSprite
	conditionalNames = c_names
	for item in c_lines:
		if item.has_method("toDialog"):
			conditionalLines.append(item.toDialog())
	startScript = p_SS
	endScript = p_ES
	
	
func toDialog() -> ZDialog:
	var processed: Array[ZText]
	processed.append(self)
	return ZDialog.new(processed)
	pass
