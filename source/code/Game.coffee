define "Game", [ "Images", "Rendering", "Input", "MainLoop", "Logic", "Graphics" ], ( Images, Rendering, Input, MainLoop, Logic, Graphics )->
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
		currentInput = Input.createCurrentInput()
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
