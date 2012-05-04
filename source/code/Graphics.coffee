define "Graphics", [ "Rendering", "Camera", "Vec2", "Gladiators" ], ( Rendering, Camera, Vec2, Gladiators ) ->
	weaponOffsets =
		"spear" :
			front: [ -6,  8 ]
			back : [  6,  8 ]
		"sword":
			front: [ -4, -4 ]
			back : [  4, -4 ]
		"shield":
			front: [  0,  4 ]
			back : [  0,  4 ]

	actionTexts =
		"ready" : "Ready!"
		"attack": "Attacking..."
		"block" : "Blocking..."

	appendBar = ( renderables, centerPosition, maxWidth, width, height ) ->
		position = Vec2.copy( centerPosition )
		Vec2.add( position, [ -maxWidth / 2, 0 ] )

		bar = Rendering.createRenderable( "rectangle" )
		bar.position = position
		bar.resource =
			size : [ width, height ]
			color: "rgb(255,0,0)"

		border = Rendering.createRenderable( "rectangleOutline" )
		border.position = position
		border.resource =
			size : [ maxWidth, height ]
			color: "rgb(0,0,0)"

		renderables.push( bar )
		renderables.push( border )

	appendGladiator = ( renderables, position, gladiator ) ->
		renderable = Rendering.createRenderable( "image" )
		renderable.resourceId = "images/gladiator-#{ gladiator.facing }.png"
		renderable.position   = position

		renderables.push( renderable )

	appendWeapon = ( renderables, weapon, facing, gladiatorPosition ) ->
		renderable = Rendering.createRenderable( "image" )
		renderable.resourceId = "images/#{ weapon }-#{ facing }.png"

		position = Vec2.copy( gladiatorPosition )
		offset   = weaponOffsets[ weapon ][ facing ]
		Vec2.add( position, offset )
		renderable.position = position

		renderables.push( renderable )

	appendHealthBar = ( renderables, gladiator, gladiatorPosition ) ->
		position = Vec2.copy( gladiatorPosition )
		Vec2.add( position, [ 0, -60 ] )

		maxWidth = 60
		width    = maxWidth * gladiator.health / Gladiators.maxHealth
		height   = 20

		appendBar(
			renderables,
			position,
			maxWidth,
			width,
			height )

	appendAction = ( renderables, gladiator, gladiatorPosition ) ->
		statusPosition = Vec2.copy( gladiatorPosition )
		Vec2.add( statusPosition, [ 0, 50 ] )

		status = Rendering.createRenderable( "text" )
		status.position = statusPosition
		status.resource =
			string  : actionTexts[ gladiator.action ]
			centered: true
			border  : false

			font       : "bold 13pt Arial Black"
			textColor  : "rgb(0,0,0)"
			borderColor: "rgb(0,0,0)"
			borderWidth: 2

		renderables.push( status )


		unless gladiator.action == "ready"
			barPosition = Vec2.copy( statusPosition )
			Vec2.add( barPosition, [ 0, 8 ] )

			maxChargeForAction =
				Gladiators.maxChargeByAction[ gladiator.action ]

			normWidth = 80
			maxWidth = maxChargeForAction / Gladiators.maxCharge * normWidth
			width  = gladiator.charge / maxChargeForAction * maxWidth
			height = 10

			appendBar(
				renderables,
				barPosition,
				maxWidth,
				width,
				height )

	module =
		createRenderState: ->
			renderState =
				camera: Camera.createCamera()
				renderables: []

		updateRenderState: ( renderState, gameState ) ->
			renderState.camera.position = Vec2.copy( gameState.focus )


			renderState.renderables.length = 0

			for entityId, gladiator of gameState.components.gladiators
				position = gameState.components.positions[ entityId ]

				appendGladiator(
					renderState.renderables,
					position,
					gladiator )
				appendWeapon(
					renderState.renderables,
					gladiator.weapon,
					gladiator.facing,
					position )
				appendHealthBar(
					renderState.renderables,
					gladiator,
					position )
				appendAction(
					renderState.renderables,
					gladiator,
					position )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
