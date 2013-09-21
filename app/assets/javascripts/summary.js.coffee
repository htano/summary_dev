# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

overFlag = false
BLANK = ''
oldContent = ''

@loadEditForm = ->
	firstEditFlag = document.getElementById('firstEditFlag')
	if firstEditFlag != null and firstEditFlag.value.length > 0
		document.getElementById('content').style.color = 'gray'
	else
		oldContent = document.getElementById('content').value

@clearContent = ->
	firstEditFlag = document.getElementById('firstEditFlag')
	if firstEditFlag.value.length > 0
		document.getElementById('content').value = BLANK
		document.getElementById('content').style.color = 'black'
		document.getElementById('firstEditFlag').value = BLANK

@clickClearButton = ->
	if confirm "clear summary?"
		document.getElementById('content').value = 'Please edit summary within 300 characters.'
		document.getElementById('content').style.color = 'gray'
		document.getElementById('count').innerHTML = '0'
		document.getElementById('count').setAttribute('class', 'count');
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
		form = $('.edit_form')
		form.submit()

@clickRestoreButton = ->
	if confirm "restore summary?"
		document.getElementById('content').value = oldContent
		countContentCharacters()
	else
		return false

@countContentCharacters = ->
	max = 300

	content = document.getElementById('content').value
	ret = content.match(/\n|\r\n/g)
	if ret != null
		if ret.length > 29
			estr = escape(content)
			en = estr.length
			em = en-3
			estr2 = estr.slice(0, em)
			content = unescape(estr2)
			document.getElementById('content').value = content
			alert "Please edit summary within 30 rows."

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
