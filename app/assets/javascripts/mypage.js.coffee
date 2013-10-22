# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
disableButton = (elem) ->
  $(elem).css("background-color", "#ddd").unwrap()

wrapAll = (className, params, checkedNum, articleID, page) ->
  $(".#{className}>#mark-as-read-btn").wrap("<a href=/mypage/mark_as_read?#{params}#{page}></a>")
  $(".#{className}>#mark-as-unread-btn").wrap("<a href=/mypage/mark_as_unread?#{params}#{page}></a>")
  $(".#{className}>#mark-as-favorite-btn").wrap("<a href=/mypage/mark_as_favorite?#{params}#{page}></a>")
  $(".#{className}>#mark-off-favorite-btn").wrap("<a href=/mypage/mark_off_favorite?#{params}#{page}></a>")
  $(".#{className}>#delete-btn").wrap("<a href=/mypage/delete_article?#{params}#{page}></a>")
  $(".#{className}>#delete-summary-btn").wrap("<a href=/mypage/delete_summary?#{params}#{page}></a>")

@clickArticleCheckBox = (formName, className, page) ->
  checkbox = document.getElementsByName(formName.name).item(0)
  checkboxNum = checkbox.length

  checkedNum = 0
  articleIDs = []
  i = 1
  while i < checkboxNum
    if checkbox.elements[i].checked
      checkedNum++
      articleID = checkbox.elements[i].value
      articleIDs.push(articleID)
    i++

  if checkedNum is 0
    disableButton(".#{className}>a>div")
  else if checkedNum is 1
    $(".#{className}>div").css("background-color", "white")

  if checkedNum > 0
    i = 0
    params = ""
    while i < articleIDs.length
      params += "article_ids[]=" + "#{articleIDs[i]}&"
      i++

    $(".#{className}>a>div").unwrap()
    wrapAll(className, params, checkedNum, articleIDs, page)

@clickCheckBoxForClip = (name) ->
  mainCheckbox     = document.main_checkbox
  summaryCheckbox  = document.summary_checkbox
  favoriteCheckbox = document.favorite_checkbox
  readCheckbox     = document.read_checkbox

  checkboxNum = mainCheckbox.elements.length + summaryCheckbox.elements.length + readCheckbox.elements.length + favoriteCheckbox.elements.length

  checkedNum = 0
  articleIDs = []

  # main tab
  i = 1
  while i < mainCheckbox.elements.length
    if mainCheckbox.elements[i].checked
      checkedNum++
      articleID = mainCheckbox.elements[i].value
      articleIDs.push(articleID)
    i++
  # summary tab
  i = 1
  while i < summaryCheckbox.elements.length
    if summaryCheckbox.elements[i].checked
      checkedNum++
      articleID = summaryCheckbox.elements[i].value
      articleIDs.push(articleID)
    i++
  # favorite tab
  i = 1
  while i < favoriteCheckbox.elements.length
    if favoriteCheckbox.elements[i].checked
      checkedNum++
      articleID = favoriteCheckbox.elements[i].value
      articleIDs.push(articleID)
    i++
  # read tab
  i = 1
  while i < readCheckbox.elements.length
    if readCheckbox.elements[i].checked
      checkedNum++
      articleID = readCheckbox.elements[i].value
      articleIDs.push(articleID)
    i++

  clipBtn = document.getElementById('clip-btn')

  if checkedNum is 0
    clipBtn.style.backgroundColor = "#ddd"
    $("a>#clip-btn").unwrap()
  else
    clipBtn.style.backgroundColor = "white"

  # create link
  if checkedNum > 0
    i = 0
    params = ""
    while i < articleIDs.length
      params += "article_ids[]=" + "#{articleIDs[i]}&"
      i++

    $("a>#clip-btn").unwrap()
    $("div>#clip-btn").wrap("<a href='/mypage/clip?name=#{name}&#{params}'></a>")

@checkAll = (checker, formName) ->
  form = document.getElementById(formName)
  checkboxNum = form.length

  i = 1
  value = document.getElementById(checker).checked
  while i < checkboxNum
    form.elements[i].checked = value
    i++
  form.elements[1].onclick() unless i is 1

currentTab = "main"
getPage = (tab) ->
  page = "mpage"
  switch tab
    when "main"
      page = "mpage"
    when "summary"
      page = "spage"
    when "favorite"
      page = "fpage"
    when "read"
      page = "rpage"
    else
  page

replaceRef = (tab, num) ->
  currentPage = getPage(currentTab)
  replacePage = getPage(tab)
  i = 1
  while i < num+1
    replaceURL = $("#sort#{i} a").attr("href").replace(currentPage, replacePage)
    $("#sort#{i} a").attr("href", "#{replaceURL}")
    i++

changeSortRef = (tab, sortNum) ->
  replaceRef(tab, sortNum)

@setCurrentTab = (tab, sortNum) ->
  if currentTab != tab
    changeSortRef(tab, sortNum)
    currentTab = tab

@getCurrentTab = ->
  currentTab

@toggleFollowBtn = ->
  $(document).ready ->
    $("#unfollow-button").hover (->
      $(this).val "unfollow"
      $(this).removeClass("btn-primary").addClass("btn-danger");
    ), ->
      $(this).val "following"
      $(this).removeClass("btn-danger").addClass("btn-primary")

scrollNavbar = ->
  win = $(window)
  overwriteLeft = ->
    scrollLeft = win.scrollLeft()
    $(".navbar-fixed-top").css "left", -scrollLeft + "px"

  win.scroll overwriteLeft
  overwriteLeft()

scrollNavbar()