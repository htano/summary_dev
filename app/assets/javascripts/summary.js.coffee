# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

overFlag = false
BLANK = ''

@clearContent = ->
	firstEditFlag = document.getElementById('firstEditFlag')
	if firstEditFlag.value.length > 0
		document.getElementById('content').value = BLANK
		document.getElementById('firstEditFlag').value = BLANK

@clickClearButton = ->
	if confirm "Clear?"
		document.getElementById('content').value = 'Please edit summary within 300 characters.'
		document.getElementById('count').innerHTML = '0'
		document.getElementById('firstEditFlag').value = 'true'
	else
		return false


@clickEditButton = ->
	content = document.getElementById('content').value
	content_num = content.replace(/\n|\r\n/g,"").length
	firstEditFlag = document.getElementById('firstEditFlag')
	if content_num is 0 or firstEditFlag.value.length > 0
		alert 'Please edit summary.'
		return false
	else
		document.getElementById('edit').disabled = 'true'
		document.getElementById('clear').disabled = 'true'
		document.getElementById('submit').disabled = BLANK
		document.getElementById('back').disabled = BLANK
		content.readOnly = 'true'
		content.setAttribute('class', 'content_disabled'); 

@clickBackButton = ->
	document.getElementById('edit').disabled = BLANK
	document.getElementById('clear').disabled = BLANK
	document.getElementById('submit').disabled = 'true'
	document.getElementById('back').disabled = 'true'
	content.readOnly = BLANK
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
		document.getElementById('edit').disabled = BLANK
		overFlag = false

	document.getElementById('count').innerHTML = content_num
