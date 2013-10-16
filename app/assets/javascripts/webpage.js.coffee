# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

BLANK = ''

@loadConfirmView = ->
  text_list = []
  for i in [1...11]
    text_value = (document.getElementById('tag_text_' + i).value)
    unless document.getElementById('recommend_tag_' + text_value) == null
      document.getElementById('recommend_tag_' + text_value).setAttribute('class', 'recommend_tag_pushed')

    unless document.getElementById('recent_tag_' + text_value) == null
      document.getElementById('recent_tag_' + text_value).setAttribute('class', 'recent_tag_pushed')

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
  $("#tag_clear").click ->
    for i in [1...11]
      document.getElementById('tag_text_' + i).value = BLANK
    $("#recommend_tags").find("span").removeClass('recommend_tag_pushed')
    $("#recommend_tags").find("span").addClass('recommend_tag')
    $("#recent_tags").find("span").removeClass('recent_tag_pushed')
    $("#recent_tags").find("span").addClass('recent_tag')

@clickRecommendTag = (value) ->
  tag_class = document.getElementById('recommend_tag_' + value).getAttribute('class')
  if tag_class == 'recommend_tag'
    text_list = []
    for i in [1...11]
      text_list.push(document.getElementById('tag_text_' + i).value)

    unless text_list.indexOf(value) == -1
      document.getElementById('recommend_tag_' + value).setAttribute('class', 'recommend_tag_pushed')
      return

    for i in [1...11]
      if document.getElementById('tag_text_' + i).value == BLANK
        document.getElementById('tag_text_' + i).value = value
        document.getElementById('recommend_tag_' + value).setAttribute('class', 'recommend_tag_pushed')
        unless document.getElementById('recent_tag_' + value) == null
          document.getElementById('recent_tag_' + value).setAttribute('class', 'recent_tag_pushed')
        return
    alert "Please set tags within 10."

  else
    for i in [1...11]
      if document.getElementById('tag_text_' + i).value == value
        document.getElementById('tag_text_' + i).value = BLANK
        document.getElementById('recommend_tag_' + value).setAttribute('class', 'recommend_tag')
        unless document.getElementById('recent_tag_' + value) == null
          document.getElementById('recent_tag_' + value).setAttribute('class', 'recent_tag')
        return

@clickRecentTag = (value) ->
  tag_class = document.getElementById('recent_tag_' + value).getAttribute('class')
  if tag_class == 'recent_tag'
    text_list = []
    for i in [1...11]
      text_list.push(document.getElementById('tag_text_' + i).value)

    unless text_list.indexOf(value) == -1
      document.getElementById('recent_tag_' + value).setAttribute('class', 'recent_tag_pushed')
      return

    for i in [1...11]
      if document.getElementById('tag_text_' + i).value == BLANK
        document.getElementById('tag_text_' + i).value = value
        document.getElementById('recent_tag_' + value).setAttribute('class', 'recent_tag_pushed')
        unless document.getElementById('recommend_tag_' + value) == null
          document.getElementById('recommend_tag_' + value).setAttribute('class', 'recommend_tag_pushed')
        return
    alert "Please set tags within 10."

  else
    for i in [1...11]
      if document.getElementById('tag_text_' + i).value == value
        document.getElementById('tag_text_' + i).value = BLANK
        document.getElementById('recent_tag_' + value).setAttribute('class', 'recent_tag')
        unless document.getElementById('recommend_tag_' + value) == null
          document.getElementById('recommend_tag_' + value).setAttribute('class', 'recommend_tag')
        return

@ckick_submit_button = ->
  document.getElementById('submit').disabled = 'true'
