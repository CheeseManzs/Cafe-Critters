class_name ZText
extends Resource
## Custom data type that stores a piece of dialogue that NPCs can use.
## Stores everything needed for the dialogue menu.
## Notably, ZTexts are not used by the dialogue system itself.
## Rather, ZDialogues are used, which are just arrays of ZTexts.


@export var text: String # The physical text to be displayed.
@export var speakerName: String # The name to be written out in the name display.
@export var speakerSprite: Texture # The sprite to be referenced as the speaker.

# The text object itself declares if the player gets to respond or not.
# ConditionalNames refers to the options presented to the player.
# ConditionalLines refers to ZDialog/ZText objects that play after the player makes the respective choice.
# e.g. the first option plays the first conditionalLine, the second plays the second
@export var conditionalNames: Array[String]
@export var conditionalLines: Array[Resource]

# temp variables for custom script handling when dialogue is read.
# not sure how i'll do this yet.
@export var startScript: Script
@export var endScript: Script

# placeholder variables.
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
	
# returns a ZDialog that contains a single ZText (this one).
func toDialog() -> ZDialog:
	var processed: Array[ZText]
	processed.append(self)
	return ZDialog.new(processed)
	pass
