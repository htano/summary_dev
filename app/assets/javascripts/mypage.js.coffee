# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@renewControlIssue = (className, params, page) ->
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
    $("#article-controller>.#{className}>div>a").addClass("disabled").css("background-color", "#ddd")
  else
    $("#article-controller>.#{className}>div>a").removeClass("disabled").css("background-color", "white")


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

@checkAll = (tab, defVal) ->
  checker = tab + '-check-all'
  formName = tab + '-check-form'

  form = document.getElementById(formName)
  checkboxNum = form.length

  isSetVal = (if typeof defVal == "undefined" then false else true)
  value = (if isSetVal then defVal else document.getElementById(checker).checked)
  i = (if isSetVal then 0 else 1)

  while i < checkboxNum
    form.elements[i].checked = value
    i++
  form.elements[1].onclick() unless i is 1

currentTab = "main"
@getPage = (tab) ->
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

@changeSortRef = (tab) ->
  currentPage = getPage(currentTab)
  replacePage = getPage(tab)
  $(".sort-type>a").each ->
    replaceURL = $(this).attr("href").replace(currentPage, replacePage)
    $(this).attr("href", "#{replaceURL}")

@setCurrentTab = (tab) ->
  if currentTab != tab
    changeSortRef(tab)
    currentTab = tab

@getCurrentTab = ->
  currentTab

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
  if result == ''
    result = defaultVal
  result

@delCookie = (name) ->
  # console.debug "called delCookie"
  cookieName = name + '='
  date = new Date()
  date.setYear date.getYear() - 1
  document.cookie = cookieName + ";expires=" + date.toGMTString()

@activateTab = (tab) ->
  if typeof tab == 'undefined' || tab == ''
    tab = 'main'
  $(".#{tab}").addClass('active')

@makeSortLink = (tab) ->
  if typeof tab == 'undefined' || tab == ''
    tab = 'main'
  changeSortRef(tab)

@clickPager = (tab) ->
  table = "main-table"
  switch tab
    when "mpage"
      table = "main-table"
    when "spage"
      table = "summary-table"
    when "fpage"
      table = "favorite-table"
    when "rpage"
      table = "read-table"
    else
  console.debug "table : " + table
  $("." + table).hide()
  $("#" + table + "-loader").show()

scrollNavbar = ->
  win = $(window)
  overwriteLeft = ->
    scrollLeft = win.scrollLeft()
    $(".navbar-fixed-top").css "left", -scrollLeft + "px"

  win.scroll overwriteLeft
  overwriteLeft()

scrollNavbar()