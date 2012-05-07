define "Game", [ "Images", "ModifiedRendering", "ModifiedInput", "MainLoop", "Logic", "Graphics" ], ( Images, Rendering, Input, MainLoop, Logic, Graphics )->
	imagePaths = [
		"images/gladiator-front.png"
		"images/spear-front.png"
		"images/sword-front.png"
		"images/shield-front.png"
		"images/gladiator-back.png"
		"images/spear-back.png"
		"images/sword-back.png"
		"images/shield-back.png" ]

	Images.loadImages imagePaths, ( rawImages ) ->
		images = Images.process( rawImages )

		renderData =
			"image": images

		Rendering.drawFunctions[ "text" ] = ( renderable, context, text ) ->
			context.fillStyle = text.textColor || "rgb(0,0,0)"
			if text.font?
				context.font = text.font
			if text.bold?
				context.font = "bold #{ context.font }"

			xPos = if text.centered
				renderable.position[ 0 ] -
					context.measureText( text.string ).width / 2
			else
				renderable.position[ 0 ]

			context.fillText(
				text.string,
				xPos,
				renderable.position[ 1 ] )

			if text.border
				context.strokeStyle = text.borderColor
				context.lineWidth   = text.borderWidth
				
				context.strokeText(
					text.string,
					xPos,
					renderable.position[ 1 ] )

		# Some keys have unwanted default behavior on website, like scrolling.
		# Fortunately we can tell the Input module to prevent the default
		# behavior of some keys.
		Input.preventDefaultFor( [
			"up arrow"
			"down arrow"
			"left arrow"
			"right arrow"
			"space" ] )

		display      = Rendering.createDisplay()
		currentInput = Input.createCurrentInput( display )
		gameState    = Logic.createGameState()
		renderState  = Graphics.createRenderState()

		Logic.initGameState( gameState )

		MainLoop.execute ( currentTimeInS, passedTimeInS ) ->
			Logic.updateGameState(
				gameState,
				currentInput,
				currentTimeInS,
				passedTimeInS )
			Graphics.updateRenderState(
				renderState,
				gameState )
			Rendering.render(
				Rendering.drawFunctions,
				display,
				renderData,
				renderState.renderables )
