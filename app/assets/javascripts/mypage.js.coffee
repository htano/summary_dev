# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
disableButton = (elem) ->
  $(elem).css("background-color", "#ddd").unwrap()

wrapAll = (class_name, params, checked_num, article_ids, page) ->
  $(".#{class_name}>#mark-as-read-btn").wrap("<a href=/mypage/mark_as_read?#{params}#{page}></a>")
  $(".#{class_name}>#mark-as-unread-btn").wrap("<a href=/mypage/mark_as_unread?#{params}#{page}></a>")
  if checked_num == 1
    $(".#{class_name}>#edit-summary-btn").wrap("<a href='/summary/#{article_ids}/edit'}></a>")
  $(".#{class_name}>#mark-as-favorite-btn").wrap("<a href=/mypage/mark_as_favorite?#{params}#{page}></a>")
  $(".#{class_name}>#mark-off-favorite-btn").wrap("<a href=/mypage/mark_off_favorite?#{params}#{page}></a>")
  $(".#{class_name}>#delete-btn").wrap("<a href=/mypage/delete_article?#{params}#{page}></a>")
  $(".#{class_name}>#delete-summary-btn").wrap("<a href=/mypage/delete_summary?#{params}#{page}></a>")

@clickArticleCheckBox = (form_name, class_name, page) ->
  checkbox = document.getElementsByName(form_name.name).item(0)
  checkbox_num = checkbox.length

  checked_num = 0
  article_ids = []
  i = 1
  while i < checkbox_num
    if checkbox.elements[i].checked
      checked_num++
      article_id = checkbox.elements[i].value
      article_ids.push(article_id)
    i++

  if checked_num is 0
    disableButton(".#{class_name}>a>div")
  else if checked_num is 1
    $(".#{class_name}>div").css("background-color", "white")
  else if checked_num is 2
    disableButton(".#{class_name}>a>#edit-summary-btn")

  if checked_num > 0
    # create parameters
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++

    $(".#{class_name}>a>div").unwrap()
    wrapAll(class_name, params, checked_num, article_ids, page)

@clickCheckBoxForClip = (name) ->
  main_checkbox     = document.main_checkbox
  summary_checkbox  = document.summary_checkbox
  # TODO : add favorite checkbox
  favorite_checkbox = document.favorite_checkbox
  read_checkbox     = document.read_checkbox

  checkbox_num = main_checkbox.elements.length + summary_checkbox.elements.length + read_checkbox.elements.length + favorite_checkbox.elements.length

  checked_num = 0
  article_ids = []

  # main tab
  i = 1
  while i < main_checkbox.elements.length
    if main_checkbox.elements[i].checked
      checked_num++
      article_id = main_checkbox.elements[i].value
      article_ids.push(article_id)
    i++
  # summary tab
  i = 1
  while i < summary_checkbox.elements.length
    if summary_checkbox.elements[i].checked
      checked_num++
      article_id = summary_checkbox.elements[i].value
      article_ids.push(article_id)
    i++
  # favorite tab
  i = 1
  while i < favorite_checkbox.elements.length
    if favorite_checkbox.elements[i].checked
      checked_num++
      article_id = favorite_checkbox.elements[i].value
      article_ids.push(article_id)
    i++
  # read tab
  i = 1
  while i < read_checkbox.elements.length
    if read_checkbox.elements[i].checked
      checked_num++
      article_id = read_checkbox.elements[i].value
      article_ids.push(article_id)
    i++

#  console.debug ("checked num = #{checked_num}")
  clip_btn = document.getElementById('clip-btn')

  if checked_num is 0
    clip_btn.style.backgroundColor = "#ddd"
    $("a>#clip-btn").unwrap()
  else
    clip_btn.style.backgroundColor = "white"

  # create link
  if checked_num > 0
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
#    console.debug params

    $("a>#clip-btn").unwrap()
    $("div>#clip-btn").wrap("<a href='/mypage/clip?name=#{name}&#{params}'></a>")

@checkAll = (checker, form_name) ->
  form = document.getElementById(form_name)
#  console.debug "form name = #{form.name}, form length = #{form.length}"
  checkbox_num = form.length

  i = 1
  value = document.getElementById(checker).checked
#  console.debug "value = #{value}"
  while i < checkbox_num
    form.elements[i].checked = value
    i++
  form.elements[1].onclick() unless i is 1

scrollNavbar = ->
  win = $(window)
  overwriteLeft = ->
    scrollLeft = win.scrollLeft()
    $(".navbar-fixed-top").css "left", -scrollLeft + "px"

  win.scroll overwriteLeft
  overwriteLeft()

scrollNavbar()