# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

BLANK = ''

@hide_navbar_text = ->
  $("#searchtext").hide 10
  $("#search").hide 10

@set_option_area = ->
  type = $("#type").val()
  sort = $("#sort").val()
  focus = $("#focus").val()
  switch type
    when "1"
      set_type_content_selected()
    when "2"
      set_type_tag_selected()
    when "3"
      set_type_domain_selected()
###
  switch sort
    when "1"
      set_sort_Newest_selected()
    when "2"
      set_sort_summary_num_selected()
    when "3"
      set_sort_user_num_selected()
###
$ ->
  $("#type_content").click ->
    $("#type").val(1)
    set_type_content_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#type_tag").click ->
    $("#type").val(2)
    set_type_tag_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#type_domain").click ->
    $("#type").val(3)
    set_type_domain_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#not_read_only").click ->
    isChecked = $("#not_read_only:checked").val()
    if isChecked
      $(".article_contents").hide 10
    else
      $(".article_contents").show 10

@set_type_content_selected = ->
  $("#type_content").removeClass()
  $("#type_tag").removeClass()
  $("#type_domain").removeClass()
  $("#type_content").addClass("selected")
  $("#type_tag").addClass("no_selected")
  $("#type_domain").addClass("no_selected")

@set_type_tag_selected = ->
  $("#type_content").removeClass()
  $("#type_tag").removeClass()
  $("#type_domain").removeClass()
  $("#type_content").addClass("no_selected")
  $("#type_tag").addClass("selected")
  $("#type_domain").addClass("no_selected")

@set_type_domain_selected = ->
  $("#type_content").removeClass()
  $("#type_tag").removeClass()
  $("#type_domain").removeClass()
  $("#type_content").addClass("no_selected")
  $("#type_tag").addClass("no_selected")
  $("#type_domain").addClass("selected")