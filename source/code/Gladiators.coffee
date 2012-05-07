define "Gladiators", [], ->
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

						selected: false

						action: "ready"
						charge: 0

		applyInput: ( currentInput, gladiators, positions ) ->
			for entityId, gladiator of gladiators
				position = positions[ entityId ]

				minX = position[ 0 ] - module.selectionRectangleSize[ 0 ] / 2
				minY = position[ 1 ] - module.selectionRectangleSize[ 1 ] / 2
				maxX = position[ 0 ] + module.selectionRectangleSize[ 0 ] / 2
				maxY = position[ 1 ] + module.selectionRectangleSize[ 1 ] / 2

				pointerX = currentInput.pointerPosition[ 0 ]
				pointerY = currentInput.pointerPosition[ 1 ]

				if minX < pointerX < maxX && minY < pointerY < maxY
					gladiator.selected = true
				else
					gladiator.selected = false
