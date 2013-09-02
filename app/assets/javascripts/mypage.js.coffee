# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@clickCheckbox = ->
  article_chkbox = document.article_checkbox
  article_num = article_chkbox.elements.length

  checked_num = 0
  article_ids = []

  i = 0

  while i < article_num
    if article_chkbox.elements[i].checked
      checked_num++
      article_id = article_chkbox.elements[i].value
      article_ids.push(article_id)
    i++

  # handle layout
  mark_as_read_btn     = document.getElementById('mark_as_read_btn')
  edit_summary_btn     = document.getElementById('edit_summary_btn')
  mark_as_favorite_btn = document.getElementById('mark_as_favorite_btn')
  delete_btn           = document.getElementById('delete_btn')

  if checked_num is 0
    mark_as_read_btn.style.backgroundColor     = "#ddd"
    $("a>#mark_as_read_btn").unwrap()

    edit_summary_btn.style.backgroundColor     = "#ddd"
    $("a>#edit_summary_btn").unwrap()

    mark_as_favorite_btn.style.backgroundColor = "#ddd"
    $("a>#mark_as_favorite_btn").unwrap()

    delete_btn.style.backgroundColor           = "#ddd"
    $("a>#delete_btn").unwrap()

  else if checked_num is 1
    mark_as_read_btn.style.backgroundColor     = "white"
    edit_summary_btn.style.backgroundColor     = "white"
    mark_as_favorite_btn.style.backgroundColor = "white"
    delete_btn.style.backgroundColor           = "white"
    
  else if checked_num is 2
    edit_summary_btn.style.backgroundColor = "#ddd"
    $("a>#edit_summary_btn").unwrap()

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

    $("a>#mark_as_read_btn").unwrap()
    $("a>#edit_summary_btn").unwrap()
    $("a>#mark_as_favorite_btn").unwrap()
    $("a>#delete_btn").unwrap()

    $("div>#mark_as_read_btn").wrap("<a href=/mypage/mark_as_read?#{params}></a>")
    if checked_num == 1
      $("div>#edit_summary_btn").wrap("<a href='/summary/#{article_ids}/edit'></a>")
    $("div>#mark_as_favorite_btn").wrap("<a href='/mypage/index'></a>")
    $("div>#delete_btn").wrap("<a href='/mypage/delete?#{params}'></a>")
