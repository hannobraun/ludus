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

						selected: true

						action: "ready"
						charge: 0
