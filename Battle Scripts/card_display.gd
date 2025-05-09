## Physical UI element that displays a card during battle.
## Likely can be repurposed elsewhere, hopefully. -A
class_name CardDisplay
extends Control

@export var titleLabel: RichTextLabel
@export var descLabel: RichTextLabel
@export var manaLabel: RichTextLabel
@export var artTexture: TextureRect

static var currentlyDragging = false
var scaleFactor = 1
var controller: BattleController
var choiceID: int = 0
var card: Card
var originalPosition: Vector2 = Vector2.ZERO
var visiblePosition: Vector2 = Vector2.ZERO
var targetPosition: Vector2 = Vector2.ZERO
var angle = 0
var mouseOn = false
var isHidden = false
var isDisabled = false
var runAnim = false
var selected = false
var launched = false
var noAlign = false
var ignoreInput = false
var straight = true
var displayLocation = "default"
var canPress = true
var canDrag = true
var fromSide = false
var deckEditController: Control
var dragging = false
var clickable = false
var autoSend = true
var dragVelocity: Vector2 = Vector2.ZERO
var normalZIndex = 0
var handSize = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = Vector2(720,1000)
	currentlyDragging = false
	normalZIndex = z_index
	scale = Vector2(0.34,0.34)*scaleFactor
	if displayLocation == "collection" or displayLocation == "deck edit":
		position = position * 0.75
		pass
	pass # Replace with function body.

## Sets parameters of the card from the given resource. -A
func setCard(p_card: Card, cID: int, battleController: BattleController, context: String = "default", user: BattleMonster = null, target: BattleMonster = null) -> void:
	runAnim = false
	card = p_card
	titleLabel.text = card.name
	manaLabel.text = "[center][b]"+str(card.cost)+"[/b][/center]"
	choiceID = cID
	controller = battleController
	if card.art != null:
		artTexture.texture = card.art
	if user != null && target != null:
		card.setDescription(user, target)
	descLabel.text = card.description
	
	if context == "default":
		if anchor_left == anchor_right && anchor_top == anchor_bottom:
			size = Vector2(720,1000)
		## Determines how many cards are in hand and changes card size based on that. -A
		var totalChoices = float(len(controller.getActivePlayerMon().currentHand.storedCards))
		handSize = totalChoices
		var rawWidth = size.x*scale.x
		var rawHeight = size.y*scale.y
		var cardWidth = size.x*scale.x*(0.5 + totalChoices*0.25/5)
		
		var viewportRect = Vector2(1920,1080)
		
		## Determines how much to rotate the card. -A
		var firstRot = -PI/12*(totalChoices/5)
		var secondRot = PI/12*(totalChoices/5)
		var a = secondRot - firstRot
		var x = cardWidth/tan(a/totalChoices)
		var y = x*cos(a/2)
		var totalDivisor = totalChoices
		var divis = 0
		
		if totalDivisor == 1:
			divis = 1
			firstRot = 0
			secondRot = 0
		else:
			divis = choiceID/(totalChoices - 1)
		
		angle = firstRot + (secondRot - firstRot)*divis
		
		
			
		var upVec = -Vector2(cos(angle + PI/2),sin(angle + PI/2))
		var basePos = Vector2(viewportRect.x/2 - pivot_offset.x,viewportRect.y + y - pivot_offset.y - 200)
		
		#ignore everything else, print it from the side
		
		
		
		## Rotation only matters if the cards are set to be curved. Otherwise, flattens them out. -A
		if straight:
			upVec = Vector2(0, -1)
			angle = 0
			var scaler = 1
			if totalChoices >= 5:
				scaler = 0.8
			var baseDelta = Vector2(rawWidth*(divis - 0.5)*(totalChoices-1)*scaler, 0)
			basePos += baseDelta
		
		if fromSide:
			basePos = Vector2(viewportRect.x + rawHeight*2*scaleFactor,viewportRect.y/2 - rawHeight*2*scaleFactor)
			
			var scaler = 1
			if totalChoices >= 5:
				scaler = 0.8
			
			x = rawWidth*5.5*scaleFactor
			
			var baseDelta = Vector2(0, rawWidth*(divis - 0.5)*(totalChoices-1)*scaler*(0.3*scaleFactor))
			basePos += baseDelta
			upVec = Vector2(-1, 0)
			#angle += -PI/2
		
		originalPosition = basePos + upVec*0.9*x
		visiblePosition = basePos + upVec*x
		
		position = originalPosition - upVec*(500 + 300*choiceID)
		targetPosition = originalPosition
		
		
		
		rotation = angle
		await controller.get_tree().create_timer(0.1).timeout
		runAnim = true

func hideCard() -> void:
	isHidden = true
	var upVec = -Vector2(cos(angle + PI/2),sin(angle + PI/2))
	targetPosition = originalPosition - upVec*(400 + 100*choiceID)

func raise(manualBonus: float = 0):
	var upVec = -Vector2(cos(angle + PI/2),sin(angle + PI/2))
	targetPosition = visiblePosition + upVec*100*manualBonus

func launch():
	launched = true
	if !autoSend:
		return
	var upVec = -Vector2(cos(angle + PI/2),sin(angle + PI/2))
	targetPosition = visiblePosition + upVec*1500
	
func straightLaunch():
	launched = true
	if !autoSend:
		return
	var upVec = -Vector2(cos(angle + PI/2),sin(angle + PI/2))
	visiblePosition.x = position.x
	targetPosition = visiblePosition + upVec*1500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if mouseOn == false:
		scale = Vector2(0.34,0.34)*scaleFactor
	if launched:
			launch()
	if runAnim && !dragging:
		position = lerp(position, targetPosition, delta*4)
		rotation = lerp(rotation, 0.0, delta*4)
	if dragging:
		var mousePos = get_global_mouse_position()
		var oldPosition: Vector2 = global_position
		global_position = lerp(global_position, mousePos - pivot_offset*scale, delta*16)
		var deltaPos = (global_position - oldPosition)
		var oldVelocity = dragVelocity
		dragVelocity = deltaPos/max(0.00000001, delta)
		var dragAcceleration = (dragVelocity - oldVelocity)/delta
		var deltaDir = dragVelocity.normalized()
		print((dragVelocity.length()/1000.0))
		var targetRot = asin(deltaDir.x)*(dragVelocity.length()/3000.0)
		targetRot = clamp(targetRot,-0.5, 0.5)
		rotation = lerp(rotation, targetRot, delta*8)
		if global_position.y < 483 || handSize < 5:
			z_index = normalZIndex + 5

	if canDrag && mouseOn && Input.is_action_just_pressed("Primary"):
		
		#if(displayLocation == "default"):
			dragging = true
			currentlyDragging = true
	
	if (dragging && Input.is_action_just_released("Primary")) || (clickable && mouseOn && Input.is_action_just_pressed("Primary")):
		currentlyDragging = false
		dragging = false
		z_index = normalZIndex
		if canPress:
			match displayLocation:
				"default":
					print("gpos:",global_position.y)
					if clickable || (global_position.y < 240.0 || dragVelocity.y < -2000):
						sendChoice()
				"collection":
					sendToDeckEditor()	
	if isDisabled:
		setTextColor(Color.FIREBRICK)
	pass


func _on_mouse_entered() -> void:
	if ignoreInput:
		return
	if !isHidden && !isDisabled && !currentlyDragging:
		var upVec = -Vector2(cos(angle + PI/2),sin(angle + PI/2))
		raise()
	if (displayLocation == "collection" or displayLocation == "deck edit") && !currentlyDragging:
		scale = Vector2(0.5, 0.5)*scaleFactor
		z_index = 3
	mouseOn = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if ignoreInput:
		return
	if !isHidden && !selected:
		targetPosition = originalPosition
	if displayLocation == "collection" or displayLocation == "deck edit":
		scale = Vector2(0.34, 0.34)*scaleFactor
		z_index = 1
	mouseOn = false
	pass # Replace with function body.

## Called when clicked on. Tells battle_controller.gd to run the appropriate code.
func sendChoice():
	if isDisabled:
		return
	print("emitting ",choiceID)
	straightLaunch()
	controller.onHand(choiceID)
	controller.emitGUISignal()
	
	
## Called when clicked on in deck edit mode. Tells deck_edit_ui.gd to do a thing.
func sendToDeckEditor():
	if isDisabled:
		return
	deckEditController.moveCard(get_meta("half"), self.card)

func setTextColor(col: Color):
	titleLabel.set("theme_override_colors/default_color",col)
	manaLabel.set("theme_override_colors/default_color",col)

func setFaceColor(col: Color):
	$Front.self_modulate = col
