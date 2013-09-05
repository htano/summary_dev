# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

overFlag = false

@clickClearButton = ->
	if confirm "Clear?"
		document.getElementById('content').value = ''
		document.getElementById('count').innerHTML = '0'
	else
		return false


@clickEditButton = ->
	content = document.getElementById('content')
	if content.value.length is 0 
		alert 'Please input summary.'
		return false
	else
		document.getElementById('edit').disabled = 'true'
		document.getElementById('clear').disabled = 'true'
		document.getElementById('submit').disabled = ''
		document.getElementById('back').disabled = ''
		content.readOnly = 'true'
		content.setAttribute('class', 'content_disabled'); 

@clickBackButton = ->
	document.getElementById('edit').disabled = ''
	document.getElementById('clear').disabled = ''
	document.getElementById('submit').disabled = 'true'
	document.getElementById('back').disabled = 'true'
	content.readOnly = ''
	content.setAttribute('class', 'content'); 

@countContentCharacters = ->
	max = 300
	content = document.getElementById('content').value
	content_num = content.replace(/\n|\r\n/g,"").length
	if content_num > max
		content_num　= 300 - content_num
		if !overFlag
			document.getElementById('count').setAttribute('class', 'count_over');
			document.getElementById('edit').disabled = 'true'
			overFlag = true
	else if content_num <= max and overFlag
		document.getElementById('count').setAttribute('class', 'count');
		document.getElementById('edit').disabled = ''
		overFlag = false

	document.getElementById('count').innerHTML = content_num
