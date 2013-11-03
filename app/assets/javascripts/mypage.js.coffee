# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

disableControlButton = (className) ->
    $(".#{className}>#mark-as-read-btn>a").addClass("disabled").css("background-color", "#ddd")
    $(".#{className}>#mark-as-unread-btn>a").addClass("disabled").css("background-color", "#ddd")
    $(".#{className}>#mark-as-favorite-btn>a").addClass("disabled").css("background-color", "#ddd")
    $(".#{className}>#mark-off-favorite-btn>a").addClass("disabled").css("background-color", "#ddd")
    $(".#{className}>#delete-btn>a").addClass("disabled").css("background-color", "#ddd")
    $(".#{className}>#delete-summary-btn>a").addClass("disabled").css("background-color", "#ddd")

enableControlButton = (className) ->
  $(".#{className}>#mark-as-read-btn>a").removeClass("disabled").css("background-color", "white")
  $(".#{className}>#mark-as-unread-btn>a").removeClass("disabled").css("background-color", "white")
  $(".#{className}>#mark-as-favorite-btn>a").removeClass("disabled").css("background-color", "white")
  $(".#{className}>#mark-off-favorite-btn>a").removeClass("disabled").css("background-color", "white")
  $(".#{className}>#delete-btn>a").removeClass("disabled").css("background-color", "white")
  $(".#{className}>#delete-summary-btn>a").removeClass("disabled").css("background-color", "white")

renewControlIssue = (className, params, page) ->
  $(".#{className}>#mark-as-read-btn>a").attr("href", "/mypage/mark_as_read?#{params}#{page}")
  $(".#{className}>#mark-as-unread-btn>a").attr("href", "/mypage/mark_as_unread?#{params}#{page}")
  $(".#{className}>#mark-as-favorite-btn>a").attr("href", "/mypage/mark_as_favorite?#{params}#{page}")
  $(".#{className}>#mark-off-favorite-btn>a").attr("href", "/mypage/mark_off_favorite?#{params}#{page}")
  $(".#{className}>#delete-btn>a").attr("href", "/mypage/delete_article?#{params}#{page}")
  $(".#{className}>#delete-summary-btn>a").attr("href", "/mypage/delete_summary?#{params}#{page}")

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
    disableControlButton(className)
  else
    enableControlButton(className)

  if checkedNum > 0
    i = 0
    params = ""
    while i < articleIDs.length
      params += "article_ids[]=" + "#{articleIDs[i]}&"
      i++
    renewControlIssue(className, params, page)

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

  if checkedNum is 0
    $("#clip-btn>a").addClass("disabled").css("background-color", "#ddd")
  else
    $("#clip-btn>a").removeClass("disabled").css("background-color", "white")

  # create link
  if checkedNum > 0
    i = 0
    params = ""
    while i < articleIDs.length
      params += "article_ids[]=" + "#{articleIDs[i]}&"
      i++

    $("#clip-btn>a").attr("href", "/mypage/clip?name=#{name}&#{params}")

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

@toggleUnfollowBtn = ->
  $(document).ready ->
    $("#unfollow-button").hover (->
      $(this).val "unfollow"
      $(this).removeClass("btn-primary").addClass("btn-danger")
    ), ->
      $(this).val "following"
      $(this).removeClass("btn-danger").addClass("btn-primary")

@setTabInfoBeforeUnload = (name) ->
  tabBeforeUnload = "main"
  if $("#article-controller .active").hasClass("main")
    tabBeforeUnload = "main"
  else if $("#article-controller .active").hasClass("summary")
    tabBeforeUnload = "summary"
  else if $("#article-controller .active").hasClass("favorite")
    tabBeforeUnload = "favorite"
  else if $("#article-controller .active").hasClass("read")
    tabBeforeUnload = "read"
  else
  if typeof name == "undefined"
    # console.debug "set my tab cookie : " + tabBeforeUnload
    document.cookie = 'tab=' + encodeURIComponent(tabBeforeUnload)
  else
    # console.debug "set other user tab cookie :" + tabBeforeUnload 
    document.cookie = 'name=' + encodeURIComponent(name)
    document.cookie = 'other_tab=' + encodeURIComponent(tabBeforeUnload)

@getCookie = (name, defaultVal) ->
  result = defaultVal
  cookieName = name + '='
  allCookies = document.cookie
  position = allCookies.indexOf(cookieName)
  # console.debug "position : " + position
  if position != -1
    startIndex = position + cookieName.length
    endIndex = allCookies.indexOf(';', startIndex)
    if endIndex == -1
      endIndex = allCookies.length
    result = decodeURIComponent(allCookies.substring(startIndex, endIndex))
  return result

@delCookie = (name) ->
  # console.debug "called delCookie"
  cookieName = name + '='
  date = new Date()
  date.setYear date.getYear() - 1
  document.cookie = cookieName + ";expires=" + date.toGMTString()

@activateTab = (tab) ->
  if typeof tab == "undefined" || tab == ''
    tab = 'main'
  $(".#{tab}").addClass("active")

scrollNavbar = ->
  win = $(window)
  overwriteLeft = ->
    scrollLeft = win.scrollLeft()
    $(".navbar-fixed-top").css "left", -scrollLeft + "px"

  win.scroll overwriteLeft
  overwriteLeft()

scrollNavbar()