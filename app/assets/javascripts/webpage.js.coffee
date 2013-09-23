# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

BLANK = ''

@blank_check = ->
	url = document.getElementById('url').value
	if url.length is 0
		document.getElementById('add_msg').innerHTML = 'Please input URL.'
		return false

@check_url = ->
	url = document.getElementById('url').value
	if url.length is 0
		document.getElementById('add_msg').innerHTML = BLANK
		document.getElementById('submit').disabled = ''
		return
	else
		check = url.match(/(http):\/\/.+/i)
		if !check
			document.getElementById('add_msg').innerHTML = 'Please input URL format.'
			document.getElementById('submit').disabled = 'true'
		else
			document.getElementById('add_msg').innerHTML = BLANK
			document.getElementById('submit').disabled = ''
			return

$ ->
	$("#tag_checkbox").click ->
		isChecked = $("#tag_checkbox:checked").val()
		if isChecked
			$("#recommend-tags").hide()
			$("#my-tags").hide()
		else
			$("#recommend-tags").show()
			$("#my-tags").show()
$ ->
  $("#tag_plus").click ->
		for i , index in $("#recommend-tags input")
			alert "tag_plus"