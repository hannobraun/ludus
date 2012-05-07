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
		"ready"   : "Ready!"
		"attack"  : "Attacking..."
		"block"   : "Blocking..."
		"cooldown": ""

	selectionOffset = Vec2.copy( Gladiators.selectionRectangleSize )
	Vec2.scale( selectionOffset, 0.5 )

	appendBar = ( renderables, centerPosition, maxWidth, width, height, color ) ->
		position = Vec2.copy( centerPosition )
		Vec2.add( position, [ -maxWidth / 2, 0 ] )

		bar = Rendering.createRenderable( "rectangle" )
		bar.position = position
		bar.resource =
			size : [ width, height ]
			color: color

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

		color = "rgb(255,0,0)"

		appendBar(
			renderables,
			position,
			maxWidth,
			width,
			height,
			color )

	appendAction = ( renderables, gladiator, gladiatorPosition ) ->
		unless gladiator.side == "ai" and gladiator.action == "ready"
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


		unless gladiator.action == "ready" || gladiator.action == "cooldown"
			barPosition = Vec2.copy( statusPosition )
			Vec2.add( barPosition, [ 0, 8 ] )

			maxChargeForAction =
				Gladiators.maxChargeByAction[ gladiator.action ]

			normWidth = 80
			maxWidth = maxChargeForAction / Gladiators.maxCharge * normWidth
			width  = gladiator.charge / maxChargeForAction * maxWidth
			height = 7

			color = "rgb(255,255,255)"

			appendBar(
				renderables,
				barPosition,
				maxWidth,
				width,
				height,
				color )

	appendGladiators = ( renderables, gladiators, positions ) ->
		for entityId, gladiator of gladiators
			position = positions[ entityId ]

			appendGladiator(
				renderables,
				position,
				gladiator )
			appendWeapon(
				renderables,
				gladiator.weapon,
				gladiator.facing,
				position )
			appendHealthBar(
				renderables,
				gladiator,
				position )
			appendAction(
				renderables,
				gladiator,
				position )

	appendSelection = ( renderables, gladiators, positions ) ->
		for entityId, gladiator of gladiators
			if gladiator.highlighted or gladiator.selected
				position = positions[ entityId ]

				color = if gladiator.selected
					"rgb(255,255,255)"
				else
					"rgb(0,0,0)"

				selectionPosition = Vec2.copy( position )
				Vec2.subtract( selectionPosition, selectionOffset )

				selection = Rendering.createRenderable( "rectangleOutline" )
				selection.position = selectionPosition
				selection.resource =
					size : Gladiators.selectionRectangleSize
					color: color

				renderables.push( selection )

	module =
		createRenderState: ->
			renderState =
				camera: Camera.createCamera()
				renderables: []

		updateRenderState: ( renderState, gameState ) ->
			renderState.camera.position = Vec2.copy( gameState.focus )

			renderState.renderables.length = 0


			appendGladiators(
				renderState.renderables,
				gameState.components.gladiators,
				gameState.components.positions )
			appendSelection(
				renderState.renderables,
				gameState.components.gladiators,
				gameState.components.positions )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
