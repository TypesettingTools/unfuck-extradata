# some flimflammery to stop chrome from loading the dropped document in the window
document.ondrop = -> false
document.ondragover = -> false

DroppedASSFile = window.DroppedASSFile

Zepto ($) -> # equivalent to $(document).ready
	live = new Date
	messages = $('#messages')
	start = 0
	idList = []
	suspendedAnimation = {}

	pushMessage = (id, text) ->
		idList.push id
		suspendedAnimation[id] = true
		messages.append "<span id='#{id}' class='message incoming'>#{text}</span>"
		$('#' + id).bind 'oanimationend animationend webkitAnimationEnd MSAnimationEnd', (ev) ->
			ev.stopPropagation()
			shiftMessage(id)

	shiftMessage = (id) ->
		if suspendedAnimation[id]
			delete suspendedAnimation[id]
		else
			message = $('#' + id)
			message.removeClass 'incoming'
			message.addClass 'outgoing'
			setTimeout ->
				message.remove()
			, 1000

	cycleMessage = (newMessage) ->
		shiftMessage idList.shift()
		pushMessage (Math.floor Math.random()*1000000).toString(16), newMessage

	pushMessage 'message1', 'DROP A SCRIPT WITH MESSED UP EXTRADATA ON ME'

	document.getElementById('shield').ondrop = (ev) ->
		for file in ev.dataTransfer.files
			new DroppedASSFile file, cycleMessage, ++start, messages

		return false

	$('#body').on 'dragenter', (ev) ->
		$('#shield').show()

	$('#shield').on 'dragenter', (ev) ->
		cycleMessage "DROP IT"

	$('#shield').on 'dragleave', (ev) ->
		$('#shield').hide()
		cycleMessage 'DROP A SCRIPT WITH MESSED UP EXTRADATA ON ME'
