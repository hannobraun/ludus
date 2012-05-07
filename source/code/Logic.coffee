define "Logic", [ "ModifiedInput", "Entities", "Gladiators" ], ( Input, Entities, Gladiators ) ->
	entityFactories =
		"gladiator": Gladiators.createEntity

	# There are functions for creating and destroying entities in the Entities
	# module. We will mostly use shortcuts however. They are declared here and
	# defined further down in initGameState.
	createEntity  = null
	destroyEntity = null

	module =
		createGameState: ->
			gameState =
				# Change this, if you want the camera to point somewhere else.
				focus: [ 0, 0 ]

				gladiatorSelection:
					currentlySelected: null

				# Game entities are made up of components. The components will
				# be stored in this map.
				components: {}

		initGameState: ( gameState ) ->
			# These are the shortcuts we will use for creating and destroying
			# entities.
			createEntity = ( type, args ) ->
				Entities.createEntity(
					entityFactories,
					gameState.components,
					type,
					args )
			destroyEntity = ( entityId ) ->
				Entities.destroyEntity(
					gameState.components,
					entityId )

			createEntity( "gladiator", {
				position: [ -160, -100 ]
				weapon  : "spear"
				facing  : "front",
				side    : "ai" } )
			createEntity( "gladiator", {
				position: [ 0, -100 ]
				weapon  : "sword"
				facing  : "front",
				side    : "ai" } )
			createEntity( "gladiator", {
				position: [ 160, -100 ]
				weapon  : "shield"
				facing  : "front",
				side    : "ai" } )

			createEntity( "gladiator", {
				position: [ -160, 100 ]
				weapon  : "spear"
				facing  : "back",
				side    : "player" } )
			createEntity( "gladiator", {
				position: [ 0, 100 ]
				weapon  : "sword"
				facing  : "back",
				side    : "player" } )
			createEntity( "gladiator", {
				position: [ 160, 100 ]
				weapon  : "shield"
				facing  : "back",
				side    : "player" } )

		updateGameState: ( gameState, currentInput, timeInS, passedTimeInS ) ->
			Gladiators.applyInput(
				currentInput,
				gameState.components.gladiators,
				gameState.components.positions,
				gameState.gladiatorSelection )
