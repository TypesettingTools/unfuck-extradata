class DroppedASSFile

	# constructor arguments are just a file blob from a drop operation.
	constructor: ( fileBlob, @cycleMessage, @number, @messages ) ->
		if loadCallback is null
			loadCallback = ->
		if readyCallback is null
			readyCallback = ->

		@name = fileBlob.name

		fileReader = new FileReader( )

		fileReader.onloadend = ( e ) =>
			@cycleMessage "FINISHED #{@number}"
			@fixASSFile e.target.result
			# for file in fileArray

			# console.log "DocumentFragment accomplished at #{new Date()-start}ms."
			# target.append dummy
			# console.log "Rows jammed in at #{new Date()-start}ms."

			# $('.filecell').on 'click', (ev) ->
				# stuff go here

			# $('#shield').hide()

		fileReader.readAsText fileBlob

	fixASSFile: ( fileString ) ->
		extradataLines = [ ]
		lineEnding = fileString.match /\r?\n/
		fileString = fileString.replace /[^\r\n]+/g, ( line ) =>
			if line.match( /^\[Aegisub Extradata\]/ ) or line.match( /^Data:/ )
				extradataLines.push line
				return ''
			else
				return line

		fileString = fileString.replace /[\r\n]{3,}/g, lineEnding
		fileString += lineEnding + extradataLines.join lineEnding

		@file = new Blob [fileString], {type: "text/plain;charset=utf-8"}

		@size = fileString.length

		@createElement( )

	createElement: ->
		filecell = $("<div class='filecell'></div>")
		filecell.append download = $("<div class='size'>DOWNLOAD</div>")
		filecell.append name = $("<div class='filename'>#{@name}</div>")

		download.on 'click', ( ev ) =>
			saveAs @file, @name

		$('#container').append filecell

		unless @messages.hasClass 'gone'
			$('#shield').hide()
			@messages.addClass 'gone'
			@messages.bind 'oanimationend animationend webkitAnimationEnd MSAnimationEnd', =>
				@messages.hide( )

window.DroppedASSFile = DroppedASSFile
