define "Graphics", [ "Rendering", "Camera", "Vec2" ], ( Rendering, Camera, Vec2 ) ->
	module =
		createRenderState: ->
			renderState =
				camera: Camera.createCamera()
				renderables: []

		updateRenderState: ( renderState, gameState ) ->
			renderState.camera.position = Vec2.copy( gameState.focus )


			renderState.renderables.length = 0

			for entityId, position of gameState.components.positions
				imageId = gameState.components.imageIds[ entityId ]

				renderable = Rendering.createRenderable( "image" )
				renderable.resourceId = imageId
				renderable.position   = Vec2.copy( position )

				renderState.renderables.push( renderable )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
