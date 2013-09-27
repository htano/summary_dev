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

#$ ->
#	$("#tag_checkbox").click ->
#		isChecked = $("#tag_checkbox:checked").val()
#		if isChecked
#			$("#recommend-tags").hide()
#			$("#my-tags").hide()
#		else
#			$("#recommend-tags").show()
#			$("#my-tags").show()


$ ->
	$("#recommend_plus").click ->
		checked_list = []
		text_list = []
		for i in [1...11]
			text_list.push(document.getElementById('tag_text_' + i).value)

		for obj , index in $("#recommend-tags input")
			if obj.checked
				if text_list.indexOf(obj.value) == -1 and obj.value != 'on'
					checked_list.push(obj.value)

		if checked_list.length != 0
				
			for i in [1...11]
				text = text_list[i-1]
				if text == BLANK and checked_list.length != 0
					value = checked_list.shift()
					document.getElementById('tag_text_' + i).value = value
					continue

			if checked_list.length != 0
				alert "Please set tags within 10."

$ ->
	$("#recent_plus").click ->
		checked_list = []
		text_list = []
		for i in [1...11]
			text_list.push(document.getElementById('tag_text_' + i).value)

		for obj , index in $("#recent-tags input")
			if obj.checked
				if text_list.indexOf(obj.value) == -1 and obj.value != 'on'
					checked_list.push(obj.value)

		if checked_list.length != 0
				
			for i in [1...11]
				text = text_list[i-1]
				if text == BLANK and checked_list.length != 0
					value = checked_list.shift()
					document.getElementById('tag_text_' + i).value = value
					continue

			if checked_list.length != 0
				alert "Please set tags within 10."

$ ->
	$("#recommend_check").click ->
		isChecked = $("#recommend_check:checked").val()
		if isChecked
			$(".recommend-tag input").prop('checked', 'checked');  	
		else
			$(".recommend-tag input").removeAttr "checked"

$ ->
	$("#recent_check").click ->
		isChecked = $("#recent_check:checked").val()
		if isChecked
			$(".recent-tag input").prop('checked', 'checked');  	
		else
			$(".recent-tag input").removeAttr "checked"