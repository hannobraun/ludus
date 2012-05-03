define "Graphics", [ "Rendering", "Camera", "Vec2" ], ( Rendering, Camera, Vec2 ) ->
	module =
		createRenderState: ->
			renderState =
				camera: Camera.createCamera()
				renderables: []

		updateRenderState: ( renderState, gameState ) ->
			renderState.camera.position = Vec2.copy( gameState.focus )


			renderState.renderables.length = 0

			renderable = Rendering.createRenderable( "image" )
			renderable.resourceId = "images/gladiator.png"
			renderable.position   = [ 0, 0 ]

			renderState.renderables.push( renderable )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
