define "Gladiators", [ "ModifiedInput", "Tools" ], ( Input, Tools ) ->
	nextEntityId = 0

	maxChargeByAction =
		"attack"  : 100
		"block"   : 20
		"cooldown": 50

	maxCharge = 0
	for action, maxChargeForAction of maxChargeByAction
		maxCharge = Math.max( maxCharge, maxChargeForAction )

	chargePerS = 60

	module =
		maxHealth: 50

		maxChargeByAction: maxChargeByAction
		maxCharge: maxCharge

		selectionRectangleSize: [ 110, 150 ]

		createEntity: ( args ) ->
			id = nextEntityId
			nextEntityId += 1

			entity =
				id: id
				components:
					"positions": args.position
					"gladiators":
						side  : args.side
						weapon: args.weapon
						facing: args.facing
						health: module.maxHealth

						highlighted: false
						selected   : false

						action: "ready"
						charge: 0

		applyInput: ( currentInput, gladiators, positions, selection ) ->
			for entityId, gladiator of gladiators
				position = positions[ entityId ]

				mouseOverGladiator = Tools.pointInRectangle(
					currentInput.pointerPosition,
					position,
					module.selectionRectangleSize )

				if mouseOverGladiator
					gladiator.highlighted = true

					selectionKeyDown =
						Input.isKeyDown( currentInput, "left mouse button" )

					if gladiator.side == "player" and selectionKeyDown
						previouslySelected =
							gladiators[ selection.currentlySelected ]
						if previouslySelected?
							previouslySelected.selected = false

						gladiator.selected = true
						selection.currentlySelected = entityId

				else
					gladiator.highlighted = false

		handleActions: ( gameState, gladiators ) ->
			unless gameState.clickedButton == null
				gladiator =
					gladiators[ gameState.gladiatorSelection.currentlySelected ]
				gameState.gladiatorSelection.currentlySelected = null
				gladiator.selected = false

				gladiator.action = gameState.clickedButton.button
				gladiator.target = gameState.clickedButton.gladiatorId

			gameState.clickedButton = null

		updateActions: ( gladiators, passedTimeInS ) ->
			for entityId, gladiator of gladiators
				unless gladiator.action == "ready"
					gladiator.charge += chargePerS * passedTimeInS

				maxCharge = maxChargeByAction[ gladiator.action ]
				if gladiator.charge >= maxCharge
					gladiator.charge = 0
					gladiator.action = "ready"
