define "Graphics", [ "Rendering", "Camera", "Vec2" ], ( Rendering, Camera, Vec2 ) ->
	weaponOffsets =
		"spear" : [ -6,  8 ]
		"sword" : [ -2, -2 ]
		"shield": [  0,  4 ]

	appendWeapon = ( renderables, weapon, gladiatorPosition ) ->
		renderable = Rendering.createRenderable( "image" )
		renderable.resourceId = "images/#{ weapon }.png"

		position = Vec2.copy( gladiatorPosition )
		Vec2.add( position, weaponOffsets[ weapon ] )
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


			gladiatorPosition = [ 50, 50 ]


			renderable = Rendering.createRenderable( "image" )
			renderable.resourceId = "images/gladiator.png"
			renderable.position   = gladiatorPosition

			renderState.renderables.push( renderable )

			appendWeapon(
				renderState.renderables,
				"shield",
				gladiatorPosition )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
