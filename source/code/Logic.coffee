define "Logic", [ "Input", "Entities", "Gladiators" ], ( Input, Entities, Gladiators ) ->
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
				facing  : "front" } )
			createEntity( "gladiator", {
				position: [ 0, -100 ]
				weapon  : "sword"
				facing  : "front" } )
			createEntity( "gladiator", {
				position: [ 160, -100 ]
				weapon  : "shield"
				facing  : "front" } )

			createEntity( "gladiator", {
				position: [ -160, 100 ]
				weapon  : "spear"
				facing  : "back" } )
			createEntity( "gladiator", {
				position: [ 0, 100 ]
				weapon  : "sword"
				facing  : "back" } )
			createEntity( "gladiator", {
				position: [ 160, 100 ]
				weapon  : "shield"
				facing  : "back" } )

		updateGameState: ( gameState, currentInput, timeInS, passedTimeInS ) ->
			
