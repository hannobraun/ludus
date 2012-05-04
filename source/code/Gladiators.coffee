define "Gladiators", [], ->
	nextEntityId = 0

	module =
		maxHealth: 50

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
