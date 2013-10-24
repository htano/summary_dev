# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

BLANK = ''

@hide_navbar_text = ->
  $("#searchtext").hide 10
  $("#search").hide 10

@set_option_area = ->
  target = $("#target").val()
  type = $("#type").val()
  switch target
    when "1"
      set_target_article_selected()
    when "2"
      $("#target_user").click()
      set_target_user_selected()

  switch type
    when "1"
      set_type_content_selected()
    when "2"
      set_type_tag_selected()
    when "3"
      set_type_domain_selected()

$ ->
  $("#target_article").click ->
    $("#search_form").attr("action","search_article");
    set_target_article_selected()
    $(".type_area").show 10
    $("#target").val(1)

$ ->
  $("#target_user").click ->
    $("#search_form").attr("action","search_user");
    set_target_user_selected()
    $(".type_area").hide 10
    $("#target").val(2)

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

@set_target_article_selected = ->
  $("#target_article").removeClass()
  $("#target_user").removeClass()
  $("#target_article").addClass("selected")
  $("#target_user").addClass("no_selected")

@set_target_user_selected = ->
  $("#target_article").removeClass()
  $("#target_user").removeClass()
  $("#target_article").addClass("no_selected")
  $("#target_user").addClass("selected")

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