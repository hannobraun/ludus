define "Gladiators", [ "ModifiedInput" ], ( Input ) ->
	nextEntityId = 0

	maxChargeByAction =
		"attack"  : 100
		"block"   : 20
		"cooldown": 50

	maxCharge = 0
	for action, maxChargeForAction of maxChargeByAction
		maxCharge = Math.max( maxCharge, maxChargeForAction )

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
				if gladiator.side == "player" and gladiator.action == "ready"
					position = positions[ entityId ]

					rectangleSize = module.selectionRectangleSize

					minX = position[ 0 ] - rectangleSize[ 0 ] / 2
					minY = position[ 1 ] - rectangleSize[ 1 ] / 2
					maxX = position[ 0 ] + rectangleSize[ 0 ] / 2
					maxY = position[ 1 ] + rectangleSize[ 1 ] / 2

					pointerX = currentInput.pointerPosition[ 0 ]
					pointerY = currentInput.pointerPosition[ 1 ]

					if minX < pointerX < maxX and minY < pointerY < maxY
						gladiator.highlighted = true

						if Input.isKeyDown( currentInput, "left mouse button" )
							previouslySelected =
								gladiators[ selection.currentlySelected ]
							if previouslySelected?
								previouslySelected.selected = false

							gladiator.selected = true
							selection.currentlySelected = entityId

					else
						gladiator.highlighted = false
