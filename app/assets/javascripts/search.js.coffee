# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

BLANK = ''

@hide_navbar_text = ->
  $("#searchtext").hide 10
  $("#search").hide 10

@set_option_area = ->
  target = $("#target").val()
  sort = $("#sort").val()
  focus = $("#focus").val()
  switch target
    when "1"
      set_target_content_selected()
    when "2"
      set_target_tag_selected()
    when "3"
      set_target_domain_selected()
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
  $("#target_content").click ->
    $("#target").val(1)
    set_target_content_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#target_tag").click ->
    $("#target").val(2)
    set_target_tag_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#target_domain").click ->
    $("#target").val(3)
    set_target_domain_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#not_read_only").click ->
    isChecked = $("#not_read_only:checked").val()
    if isChecked
      $(".article_contents").hide 10
    else
      $(".article_contents").show 10

@set_target_content_selected = ->
  $("#target_content").removeClass()
  $("#target_tag").removeClass()
  $("#target_domain").removeClass()
  $("#target_content").addClass("selected")
  $("#target_tag").addClass("no_selected")
  $("#target_domain").addClass("no_selected")

@set_target_tag_selected = ->
  $("#target_content").removeClass()
  $("#target_tag").removeClass()
  $("#target_domain").removeClass()
  $("#target_content").addClass("no_selected")
  $("#target_tag").addClass("selected")
  $("#target_domain").addClass("no_selected")

@set_target_domain_selected = ->
  $("#target_content").removeClass()
  $("#target_tag").removeClass()
  $("#target_domain").removeClass()
  $("#target_content").addClass("no_selected")
  $("#target_tag").addClass("no_selected")
  $("#target_domain").addClass("selected")