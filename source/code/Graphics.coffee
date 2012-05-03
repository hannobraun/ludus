define "Graphics", [ "Rendering", "Camera", "Vec2" ], ( Rendering, Camera, Vec2 ) ->
	weaponOffsets =
		"spear" :
			front: [ -6,  8 ]
			back : [  6,  8 ]
		"sword":
			front: [ -2, -2 ]
			back : [ -2, -2 ]
		"shield":
			front: [  0,  4 ]
			back : [  0,  4 ]

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


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
