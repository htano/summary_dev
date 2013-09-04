# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@setContent = ->
	alert "rest"

@clickClearButton = ->
	if confirm "clear?"
		document.getElementById('content').value = ''
		document.getElementById('count').innerHTML = '0'
	else
		return false


@clickEditButton = ->
	content = document.getElementById('content')
	if content.value.length is 0 
		alert 'please input summary'
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
	document.getElementById('count').innerHTML = 
	content = document.getElementById('content').value.length
