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

	healthBarWidth  = 60
	healthBarHeight = 20

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
		Vec2.add( position, [ -healthBarWidth / 2, -60 ] )

		barWidth = healthBarWidth * gladiator.health / Gladiators.maxHealth

		bar = Rendering.createRenderable( "rectangle" )
		bar.position = position
		bar.resource =
			size : [ barWidth, healthBarHeight ]
			color: "rgb(255,0,0)"

		border = Rendering.createRenderable( "rectangleOutline" )
		border.position = position
		border.resource =
			size : [ healthBarWidth, healthBarHeight ]
			color: "rgb(0,0,0)"

		renderables.push( bar )
		renderables.push( border )

	appendAction = ( renderables, gladiator, gladiatorPosition ) ->
		position = Vec2.copy( gladiatorPosition )
		Vec2.add( position, [ 0, 50 ] )

		text = Rendering.createRenderable( "text" )
		text.position = position
		text.resource =
			string  : "Ready!"
			centered: true
			border  : false

			font       : "bold 15pt Arial Black"
			textColor  : "rgb(0,0,0)"
			borderColor: "rgb(0,0,0)"
			borderWidth: 2

		renderables.push( text )


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
