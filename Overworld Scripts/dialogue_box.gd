extends Panel
var timer = 0
var speed = 3
var isOpening = false
var currentScript: ZDialog
var currentLine = 0
var loadedChars = 0
var makeAChoice = false
var choiceButtons = []
var doneFreeing = true

signal closeDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$DialogText.normal_font_size = 12
	anchor_top = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	
	loadedChars += 1
	$DialogText.visible_characters = loadedChars
	
	if currentScript != null and isOpening == true and makeAChoice == false:
		if loadedChars >= currentScript.texts[currentLine].text.length():
			if currentScript.texts[currentLine].conditionalNames.is_empty() == false:
				makeAChoice = true
				activateChoices()
				%DialogResponses.isOpening = true
	
	if %DialogResponses.isOpening == false and %DialogResponses.timer == 0 and doneFreeing == false:
		doneFreeing = true
		for button in choiceButtons:
			button.queue_free()
		choiceButtons = []
	
	var processVal = sin(PI * timer / 2)
	anchor_top = 1 - (0.4 * processVal)
	pass

func activateChoices() -> void:
	for button in choiceButtons:
		button.queue_free()
		doneFreeing = true
		choiceButtons = []
	for i in range(currentScript.texts[currentLine].conditionalNames.size()):
		choiceButtons.append(Button.new())
		choiceButtons[i].text = currentScript.texts[currentLine].conditionalNames[i]
		choiceButtons[i].set_meta("index", i)
		choiceButtons[i].pressed.connect(self._button_pressed.bind(choiceButtons[i]))
		%DialogResponses.add_child(choiceButtons[i])
		
	
func _button_pressed(button):
	if makeAChoice == true:
		print(button.get_meta("index"))
		makeAChoice = false
		_on_player_dialogue_opened(currentScript.texts[currentLine].conditionalLines[button.get_meta("index")].toDialog())
		%DialogResponses.isOpening = false
		doneFreeing = false
		
		
		
	
		

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
	if loadedChars <= currentScript.texts[currentLine].text.length():
		loadedChars = currentScript.texts[currentLine].text.length()
	elif makeAChoice == false:
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
