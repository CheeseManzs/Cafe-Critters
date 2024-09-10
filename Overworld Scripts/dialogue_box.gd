extends Panel

## Dialogue box. Holds what's being spoken.

var timer = 0
var speed = 3
var isOpening = false

# Current set of lines to be displayed.
var currentScript: ZDialog
var currentLine = 0

# How many text characters are being rendered right now.
var loadedChars = 0

# Ensures that the appropriate actions are being taken when the player is prompted to respond.
var makeAChoice = false
var doneFreeing = true

var choiceButtons = []

signal closeDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hides the dialogue box.
	#$DialogText.normal_font_size = 12
	anchor_top = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Controls the popping-up animation of the dialogue box.
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	
	var processVal = sin(PI * timer / 2)
	anchor_top = 1 - (0.4 * processVal)
	
	# Increments the amount of visible characters, for that sweet sweet talking effect.
	loadedChars += 1
	$DialogText.visible_characters = loadedChars
	
	# Checks if the current ZText wants the player to respond or not.
	# Only activates once all the characters are done rendering.
	if currentScript != null and isOpening == true and makeAChoice == false:
		if loadedChars >= currentScript.texts[currentLine].text.length():
			if currentScript.texts[currentLine].conditionalNames.is_empty() == false:
				makeAChoice = true
				activateChoices()
				%DialogResponses.isOpening = true
	
	# Clears the generated buttons from memory once they've left the screen.
	# Also makes sure it doesn't try accessing things that don't exist.
	if %DialogResponses.isOpening == false and %DialogResponses.timer == 0 and doneFreeing == false:
		doneFreeing = true
		for button in choiceButtons:
			button.queue_free()
		choiceButtons = []
	
	pass

# Called to generate the player response buttons.
func activateChoices() -> void:
	# this only matters if the player mashes through 2 player responses before the first has time to despawn lol
	for button in choiceButtons:
		button.queue_free()
		doneFreeing = true
		choiceButtons = []
	# Creates buttons corresponding to each response and allows them to connect to this script.
	for i in range(currentScript.texts[currentLine].conditionalNames.size()):
		choiceButtons.append(Button.new())
		choiceButtons[i].text = currentScript.texts[currentLine].conditionalNames[i]
		choiceButtons[i].set_meta("index", i)
		choiceButtons[i].pressed.connect(self._button_pressed.bind(choiceButtons[i]))
		%DialogResponses.add_child(choiceButtons[i])
		
# Determines which button to press and loads the corresponding ZDialogue.
func _button_pressed(button):
	if makeAChoice == true:
		print(button.get_meta("index"))
		makeAChoice = false
		_on_player_dialogue_opened(currentScript.texts[currentLine].conditionalLines[button.get_meta("index")].toDialog())
		%DialogResponses.isOpening = false
		doneFreeing = false
		
# called to update the visual elements of the dialogue system.
func doDialog() -> void:
	#currentScript.texts[currentLine].
	$DialogText.text = currentScript.texts[currentLine].text
	$NamePanel/NameText.text = currentScript.texts[currentLine].speakerName
	%DialogPortrait.texture = currentScript.texts[currentLine].speakerSprite

func _on_player_dialogue_opened(dLine: ZDialog) -> void:
	loadedChars = 0
	currentLine = 0
	currentScript = dLine
	doDialog()
	isOpening = true
	%DialogPortrait.isOpening = true
	#anchor_top = 0.6
	pass # Replace with function body.


func _on_player_dialogue_closed() -> void:
	pass # Replace with function body.


func _on_player_dialogue_passed() -> void:
	# pressing z will immediately show current text if it's not done rendering.
	if loadedChars <= currentScript.texts[currentLine].text.length():
		loadedChars = currentScript.texts[currentLine].text.length()
	elif makeAChoice == false:
		# otherwise it advances to the next line if there is one and closes the dialog if there isn't
		currentLine += 1
		if currentLine < currentScript.texts.size():
			doDialog()
		else:
			isOpening = false
			%DialogPortrait.isOpening = false
			closeDialog.emit()
			return
		loadedChars = 0
	pass # Replace with function body.
