define "Gladiators", [], ->
	nextEntityId = 0

	maxChargeByAction =
		"attack": 100
		"block" : 20

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
						weapon: args.weapon
						facing: args.facing
						health: module.maxHealth

						action: "attack"
						charge: 10
