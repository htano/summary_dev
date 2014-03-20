# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

overFlag = false
BLANK = ''
oldContent = ''

@loadEditForm = ->
  oldContent = document.getElementById('content').value

@clearContent = ->
  document.getElementById('content').value = BLANK

@clickClearButton = ->
  content = document.getElementById('content').value
  content_num = content.replace(/\n|\r\n/g,"").length
  if content_num is 0
    return false
  else
    if confirm "要約を消去して良いですか？"
      document.getElementById('content').value = BLANK
      document.getElementById('count').innerHTML = '0'
      document.getElementById('count').setAttribute('class', 'count')
    else
      return false


@clickEditButton = ->
  content = document.getElementById('content').value
  content_num = content.replace(/\n|\r\n/g,"").length
  if overFlag
    alert '要約は300文字以内で入力して下さい。'
    return false
  else
    if content_num is 0
      alert '要約内容を入力して下さい。'
      return false
    else
      form = $('.edit_form')
      form.submit()

@clickRestoreButton = ->
  if document.getElementById('content').value != oldContent
    if confirm "編集内容を元に戻して良いですか？"
      document.getElementById('content').value = oldContent
      countContentCharacters()
    else
      return false
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
      alert "要約は30行以内で入力して下さい。"

  content_num = content.replace(/\n|\r\n/g,"").length
  if content_num > max
    content_num　= 300 - content_num
    if !overFlag
      document.getElementById('count').setAttribute('class', 'count_over')
      overFlag = true
  else if content_num <= max and overFlag
    document.getElementById('count').setAttribute('class', 'count')
    document.getElementById('edit').disabled = BLANK
    overFlag = false

  document.getElementById('count').innerHTML = content_num
