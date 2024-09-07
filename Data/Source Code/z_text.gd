class_name ZText
extends Resource

@export var text: String
@export var speakerName: String
@export var speakerSprite: Texture

func _init(p_text = "", p_speakerName = "", p_speakerSprite = null):
	text = p_text
	speakerName = p_speakerName
	speakerSprite = p_speakerSprite
	
func toDialog() -> ZDialog:
	var processed: Array[ZText]
	processed.append(self)
	return ZDialog.new(processed)
	pass
