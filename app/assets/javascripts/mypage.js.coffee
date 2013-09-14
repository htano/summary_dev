# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@clickMainCheckBox = ->
  checkbox = document.main_checkbox
  checkbox_num = checkbox.elements.length

  checked_num = 0
  article_ids = []
  i = 0

  while i < checkbox_num
    if checkbox.elements[i].checked
      checked_num++
      article_id = checkbox.elements[i].value
      article_ids.push(article_id)
    i++

  # handle layout
  mark_as_read_btn     = document.getElementById('m-mark-as-read-btn')
  edit_summary_btn     = document.getElementById('m-edit-summary-btn')
  mark_as_favorite_btn = document.getElementById('m-mark-as-favorite-btn')
  delete_btn           = document.getElementById('m-delete-btn')

  if checked_num is 0
    mark_as_read_btn.style.backgroundColor     = "#ddd"
    $("a>#m-mark-as-read-btn").unwrap()

    edit_summary_btn.style.backgroundColor     = "#ddd"
    $("a>#m-edit-summary-btn").unwrap()

    mark_as_favorite_btn.style.backgroundColor = "#ddd"
    $("a>#m-mark-as-favorite-btn").unwrap()

    delete_btn.style.backgroundColor           = "#ddd"
    $("a>#m-delete-btn").unwrap()

  else if checked_num is 1
    mark_as_read_btn.style.backgroundColor     = "white"
    edit_summary_btn.style.backgroundColor     = "white"
    mark_as_favorite_btn.style.backgroundColor = "white"
    delete_btn.style.backgroundColor           = "white"
    
  else if checked_num is 2
    edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#m-edit-summary-btn").unwrap()

#  console.debug "checked num = " + checked_num

  # create link
  if checked_num > 0
    # create parameters
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
#    console.debug params

    $("a>#m-mark-as-read-btn").unwrap()
    $("a>#m-edit-summary-btn").unwrap()
    $("a>#m-mark-as-favorite-btn").unwrap()
    $("a>#m-delete-btn").unwrap()


    $("div>#m-mark-as-read-btn").wrap("<a href=/mypage/mark_as_read?#{params}></a>")
    if checked_num == 1
      $("div>#m-edit-summary-btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#m-mark-as-favorite-btn").wrap("<a href='/mypage/mark_as_favorite?#{params}'></a>")
    $("div>#m-delete-btn").wrap("<a href='/mypage/delete_article?#{params}'></a>")

@clickFavoriteCheckBox = ->
  checkbox = document.favorite_checkbox
  checkbox_num = checkbox.elements.length

  checked_num = 0
  article_ids = []
  i = 0

  while i < checkbox_num
    if checkbox.elements[i].checked
      checked_num++
      article_id = checkbox.elements[i].value
      article_ids.push(article_id)
    i++

  # handle layout
  edit_summary_btn       = document.getElementById('f-edit-summary-btn')
  mark_off_favorite_btn  = document.getElementById('f-mark-off-favorite-btn')
  delete_btn             = document.getElementById('f-delete-btn')

  if checked_num is 0
    edit_summary_btn.style.backgroundColor      = "#ddd"
    $("a>#f-edit-summary-btn").unwrap()

    mark_off_favorite_btn.style.backgroundColor = "#ddd"
    $("a>#f-mark-off-favorite-btn").unwrap()

    delete_btn.style.backgroundColor            = "#ddd"
    $("a>#f-delete-btn").unwrap()

  else if checked_num is 1
    edit_summary_btn.style.backgroundColor      = "white"
    mark_off_favorite_btn.style.backgroundColor = "white"
    delete_btn.style.backgroundColor            = "white"
    
  else if checked_num is 2
    edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#f-edit-summary-btn").unwrap()

#  console.debug "checked num = " + checked_num

  # create link
  if checked_num > 0
    # create parameters
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
#    console.debug params

    $("a>#f-edit-summary-btn").unwrap()
    $("a>#f-mark-off-favorite-btn").unwrap()
    $("a>#f-delete-btn").unwrap()


    if checked_num == 1
      $("div>#f-edit-summary-btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#f-mark-off-favorite-btn").wrap("<a href='/mypage/mark_off_favorite?#{params}'></a>")
    $("div>#f-delete-btn").wrap("<a href='/mypage/delete_article?#{params}'></a>")

@clickReadCheckBox = ->
  checkbox = document.read_checkbox
  checkbox_num = checkbox.elements.length

  checked_num = 0
  article_ids = []
  i = 0

  while i < checkbox_num
    if checkbox.elements[i].checked
      checked_num++
      article_id = checkbox.elements[i].value
      article_ids.push(article_id)
    i++

  # handle layout
  r_mark_as_unread_btn   = document.getElementById('r-mark-as-unread-btn')
  r_edit_summary_btn     = document.getElementById('r-edit-summary-btn')
  r_mark_as_favorite_btn = document.getElementById('r-mark-as-favorite-btn')
  r_delete_btn           = document.getElementById('r-delete-btn')

  if checked_num is 0
    r_mark_as_unread_btn.style.backgroundColor = "#ddd"
    $("a>#r-mark-as-unread-btn").unwrap()

    r_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#r-edit-summary-btn").unwrap()

    r_mark_as_favorite_btn.style.backgroundColor = "#ddd"
    $("a>#r-mark-as-favorite-btn").unwrap()

    r_delete_btn.style.backgroundColor = "#ddd"
    $("a>#r-delete-btn").unwrap()

  else if checked_num is 1
    r_mark_as_unread_btn.style.backgroundColor   = "white"
    r_edit_summary_btn.style.backgroundColor     = "white"
    r_mark_as_favorite_btn.style.backgroundColor = "white"
    r_delete_btn.style.backgroundColor           = "white"
  else if checked_num is 2
    r_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#r-edit-summary-btn").unwrap

  # create link
  if checked_num > 0
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
#    console.debug params

    $("a>#r-mark-as-unread-btn").unwrap()
    $("a>#r-edit-summar-_btn").unwrap()
    $("a>#r-mark-as-favorite-btn").unwrap()
    $("a>#r-delete-btn").unwrap()


    $("div>#r-mark-as-unread-btn").wrap("<a href=/mypage/mark_as_unread?#{params}></a>")
    if checked_num == 1
      $("div>#r-edit-summary-btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#r-mark-as-favorite-btn").wrap("<a href='/mypage/mark_as_favorite?#{params}'></a>")
    $("div>#r-delete-btn").wrap("<a href='/mypage/delete_article?#{params}'></a>")

@clickSummaryCheckBox = ->
  checkbox = document.summary_checkbox
  checkbox_num = checkbox.elements.length

  checked_num = 0
  article_ids = []
  i = 0

  while i < checkbox_num
    if checkbox.elements[i].checked
      checked_num++
      article_id = checkbox.elements[i].value
      article_ids.push(article_id)
    i++

  # handle layout
  s_edit_summary_btn     = document.getElementById('s-edit-summary-btn')
  s_delete_btn           = document.getElementById('s-delete-btn')

  if checked_num is 0
    s_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#s-edit-summary-btn").unwrap()

    s_delete_btn.style.backgroundColor = "#ddd"
    $("a>#s-delete-btn").unwrap()

  else if checked_num is 1
    s_edit_summary_btn.style.backgroundColor     = "white"
    s_delete_btn.style.backgroundColor           = "white"
  else if checked_num is 2
    s_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#s-edit-summary-btn").unwrap

  # create link
  if checked_num > 0
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
#    console.debug params

    $("a>#s-edit-summary-btn").unwrap()
    $("a>#s-delete-btn").unwrap()

    if checked_num == 1
      $("div>#s-edit-summary-btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#s-delete-btn").wrap("<a href='/mypage/delete_summary?#{params}'></a>")

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
  i = 0
  while i < main_checkbox.elements.length
    if main_checkbox.elements[i].checked
      checked_num++
      article_id = main_checkbox.elements[i].value
      article_ids.push(article_id)
    i++
  # summary tab
  i = 0
  while i < summary_checkbox.elements.length
    if summary_checkbox.elements[i].checked
      checked_num++
      article_id = summary_checkbox.elements[i].value
      article_ids.push(article_id)
    i++
  # favorite tab
  i = 0
  while i < favorite_checkbox.elements.length
    if favorite_checkbox.elements[i].checked
      checked_num++
      article_id = favorite_checkbox.elements[i].value
      article_ids.push(article_id)
    i++
  # read tab
  i = 0
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

  i = 0
  value = document.getElementById(checker).checked
#  console.debug "value = #{value}"
  while i < checkbox_num
    form.elements[i].checked = value
    i++
  form.elements[0].onclick() unless i is 0

scrollNavbar = ->
  win = $(window)
  overwriteLeft = ->
    scrollLeft = win.scrollLeft()
    $(".navbar-fixed-top").css "left", -scrollLeft + "px"

  win.scroll overwriteLeft
  overwriteLeft()

scrollNavbar()