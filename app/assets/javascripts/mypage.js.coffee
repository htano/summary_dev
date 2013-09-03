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
  mark_as_read_btn     = document.getElementById('m_mark_as_read_btn')
  edit_summary_btn     = document.getElementById('m_edit_summary_btn')
  mark_as_favorite_btn = document.getElementById('m_mark_as_favorite_btn')
  delete_btn           = document.getElementById('m_delete_btn')

  if checked_num is 0
    mark_as_read_btn.style.backgroundColor     = "#ddd"
    $("a>#m_mark_as_read_btn").unwrap()

    edit_summary_btn.style.backgroundColor     = "#ddd"
    $("a>#m_edit_summary_btn").unwrap()

    mark_as_favorite_btn.style.backgroundColor = "#ddd"
    $("a>#m_mark_as_favorite_btn").unwrap()

    delete_btn.style.backgroundColor           = "#ddd"
    $("a>#m_delete_btn").unwrap()

  else if checked_num is 1
    mark_as_read_btn.style.backgroundColor     = "white"
    edit_summary_btn.style.backgroundColor     = "white"
    mark_as_favorite_btn.style.backgroundColor = "white"
    delete_btn.style.backgroundColor           = "white"
    
  else if checked_num is 2
    edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#m_edit_summary_btn").unwrap()

  console.debug "checked num = " + checked_num

  # create link
  if checked_num > 0
    # create parameters
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
    console.debug params

    $("a>#m_mark_as_read_btn").unwrap()
    $("a>#m_edit_summary_btn").unwrap()
    $("a>#m_mark_as_favorite_btn").unwrap()
    $("a>#m_delete_btn").unwrap()


    $("div>#m_mark_as_read_btn").wrap("<a href=/mypage/mark_as_read?#{params}></a>")
    if checked_num == 1
      $("div>#m_edit_summary_btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#m_mark_as_favorite_btn").wrap("<a href='/mypage/index'></a>")
    $("div>#m_delete_btn").wrap("<a href='/mypage/delete_article?#{params}'></a>")

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
  r_mark_as_unread_btn   = document.getElementById('r_mark_as_unread_btn')
  r_edit_summary_btn     = document.getElementById('r_edit_summary_btn')
  r_mark_as_favorite_btn = document.getElementById('r_mark_as_favorite_btn')
  r_delete_btn           = document.getElementById('r_delete_btn')

  if checked_num is 0
    r_mark_as_unread_btn.style.backgroundColor = "#ddd"
    $("a>#r_mark_as_unread_btn").unwrap()

    r_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#r_edit_summary_btn").unwrap()

    r_mark_as_favorite_btn.style.backgroundColor = "#ddd"
    $("a>#r_mark_as_favorite_btn").unwrap()

    r_delete_btn.style.backgroundColor = "#ddd"
    $("a>#r_delete_btn").unwrap()

  else if checked_num is 1
    r_mark_as_unread_btn.style.backgroundColor   = "white"
    r_edit_summary_btn.style.backgroundColor     = "white"
    r_mark_as_favorite_btn.style.backgroundColor = "white"
    r_delete_btn.style.backgroundColor           = "white"
  else if checked_num is 2
    r_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#r_edit_summary_btn").unwrap

  # create link
  if checked_num > 0
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
    console.debug params

    $("a>#r_mark_as_unread_btn").unwrap()
    $("a>#r_edit_summary_btn").unwrap()
    $("a>#r_mark_as_favorite_btn").unwrap()
    $("a>#r_delete_btn").unwrap()


    $("div>#r_mark_as_unread_btn").wrap("<a href=/mypage/mark_as_unread?#{params}></a>")
    if checked_num == 1
      $("div>#r_edit_summary_btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#r_mark_as_favorite_btn").wrap("<a href='/mypage/index'></a>")
    $("div>#r_delete_btn").wrap("<a href='/mypage/delete_article?#{params}'></a>")

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
  s_edit_summary_btn     = document.getElementById('s_edit_summary_btn')
  s_delete_btn           = document.getElementById('s_delete_btn')

  if checked_num is 0
    s_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#s_edit_summary_btn").unwrap()

    s_delete_btn.style.backgroundColor = "#ddd"
    $("a>#s_delete_btn").unwrap()

  else if checked_num is 1
    s_edit_summary_btn.style.backgroundColor     = "white"
    s_delete_btn.style.backgroundColor           = "white"
  else if checked_num is 2
    s_edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#s_edit_summary_btn").unwrap

  # create link
  if checked_num > 0
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
    console.debug params

    $("a>#s_edit_summary_btn").unwrap()
    $("a>#s_delete_btn").unwrap()

    if checked_num == 1
      $("div>#s_edit_summary_btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#s_delete_btn").wrap("<a href='/mypage/delete_summary?#{params}'></a>")

@clickCheckBoxForClip = ->
  main_checkbox     = document.main_checkbox
  summary_checkbox  = document.summary_checkbox
  # TODO : add favorite checkbox
#  favorite_checkbox = document.favorite_checkbox
  read_checkbox     = document.read_checkbox

  checkbox_num = main_checkbox.elements.length + summary_checkbox.elements.length + read_checkbox.elements.length
  # TODO : add favorite checkbox
#  checkbox_num = main_checkbox.elements.length + summary_checkbox.elements.length + read_checkbox.elements.length + favorite_checkbox.elements.length

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
  # TODO : add favorite checkbox
  # read tab
  i = 0
  while i < read_checkbox.elements.length
    if read_checkbox.elements[i].checked
      checked_num++
      article_id = read_checkbox.elements[i].value
      article_ids.push(article_id)
    i++

#  console.debug ("checked num = #{checked_num}")
  clip_btn = document.getElementById('clip_btn')

  if checked_num is 0
    clip_btn.style.backgroundColor = "#ddd"
    $("a>#clip_btn").unwrap()
  else
    clip_btn.style.backgroundColor = "white"

  # create link
  if checked_num > 0
    i = 0
    params = ""
    while i < article_ids.length
      params += "article_ids[]=" + "#{article_ids[i]}&"
      i++
    console.debug params

    $("a>#clip_btn").unwrap()
    $("div>#clip_btn").wrap("<a href='/mypage/clip?#{params}'></a>")
