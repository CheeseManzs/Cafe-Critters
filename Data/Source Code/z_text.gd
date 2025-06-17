class_name ZText
extends Resource
## Custom data type that stores a piece of dialogue that NPCs can use.
## Stores everything needed for the dialogue menu.
## Notably, ZTexts are not used by the dialogue system itself.
## Rather, ZDialogues are used, which are just arrays of ZTexts.

# list of dialogue effects to activate. can be timed to activate when a dialog is opened or closed.
# each effect should correspond to a certain metadata
enum EFFECTS {
	START_BATTLE, # metadata is an array holding the enemy team and a personality
	SCREENSHAKE, # metedata is empty
	FLIP_SPEAKER, # metadata is empty
	GIFT, #metadata is an array of items to be given
}



@export var text: String # The physical text to be displayed.
@export var speakerName: String # The name to be written out in the name display.
@export var speakerSprite: Texture # The sprite to be referenced as the speaker.

# The text object itself declares if the player gets to respond or not.
# ConditionalNames refers to the options presented to the player.
# ConditionalLines refers to ZDialog/ZText objects that play after the player makes the respective choice.
# e.g. the first option plays the first conditionalLine, the second plays the second
@export var conditionalNames: Array[String]
@export var conditionalLines: Array[ZDialog]

# arrays for effects that activate.
# they get passed to dialogue_box.gd, which interprets the Effect based on the metadata
@export var startEffects: Array[EFFECTS]
@export var startMetadata: Array
@export var endEffects: Array[EFFECTS]
@export var endMetadata: Array

# placeholder variables.
var emptyLines: Array[ZDialog] = []
var emptyNames: Array[String] = []
var emptyEffects: Array[EFFECTS] = []

func _init(p_text = "", p_speakerName = "", p_speakerSprite = null, c_names = emptyNames.duplicate(), 
		c_lines = emptyLines.duplicate(), p_SS = emptyEffects.duplicate(), p_ES = emptyEffects.duplicate()):
	text = p_text
	speakerName = p_speakerName
	speakerSprite = p_speakerSprite
	conditionalNames = c_names
	for item in c_lines:
		if item.has_method("toDialog"):
			conditionalLines.append(item.toDialog())
	startEffects = p_SS
	endEffects = p_ES
	
# returns a ZDialog that contains a single ZText (this one).
func toDialog() -> ZDialog:
	var processed: Array[ZText]
	processed.append(self)
	return ZDialog.new(processed)
	pass
