# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@set_option_area = ->
  condition = $("#condition").val()
  sort = $("#sort").val()
  focus = $("#focus").val()
  switch condition
    when "1"
      set_condition_tag_selected()
    when "2"
      set_condition_title_selected()
    when "3"
      set_condition_content_selected()

  switch sort
    when "1"
      set_sort_Newest_selected()
    when "2"
      set_sort_summary_num_selected()
    when "3"
      set_sort_user_num_selected()
      
  switch focus
    when "1"
      set_focus_all_selected()
    when "2"
      set_focus_reading_selected()
    when "3"
      set_focus_not_reading_selected()

$ ->
  $("#condition_tag").click ->
    $("#condition").val(1)
    $("#search_form").submit()

$ ->
  $("#condition_title").click ->
    $("#condition").val(2)
    $("#search_form").submit()

$ ->
  $("#condition_content").click ->
    $("#condition").val(3)
    $("#search_form").submit()

$ ->
  $("#sort_Newest").click ->
    $("#sort").val(1)
    $("#search_form").submit()

$ ->
  $("#sort_summary_num").click ->
    $("#sort").val(2)
    $("#search_form").submit()

$ ->
  $("#sort_user_num").click ->
    $("#sort").val(3)
    $("#search_form").submit()

$ ->
  $("#focus_all").click ->
    $("#focus").val(1)
    $("#search_form").submit()

$ ->
  $("#focus_reading").click ->
    $("#focus").val(2)
    $("#search_form").submit()

$ ->
  $("#focus_not_reading").click ->
    $("#focus").val(3)
    $("#search_form").submit()

@set_condition_tag_selected = ->
  $("#condition_tag").removeClass()
  $("#condition_title").removeClass()
  $("#condition_content").removeClass()
  $("#condition_tag").addClass("selected")
  $("#condition_title").addClass("no_selected")
  $("#condition_content").addClass("no_selected")

@set_condition_title_selected = ->
  $("#condition_tag").removeClass()
  $("#condition_title").removeClass()
  $("#condition_content").removeClass()
  $("#condition_tag").addClass("no_selected")
  $("#condition_title").addClass("selected")
  $("#condition_content").addClass("no_selected")

@set_condition_content_selected = ->
  $("#condition_tag").removeClass()
  $("#condition_title").removeClass()
  $("#condition_content").removeClass()
  $("#condition_tag").addClass("no_selected")
  $("#condition_title").addClass("no_selected")
  $("#condition_content").addClass("selected")

@set_sort_Newest_selected = ->
  $("#sort_Newest").removeClass()
  $("#sort_summary_num").removeClass()
  $("#sort_user_num").removeClass()
  $("#sort_Newest").addClass("selected")
  $("#sort_summary_num").addClass("no_selected")
  $("#sort_user_num").addClass("no_selected")

@set_sort_summary_num_selected = ->
  $("#sort_Newest").removeClass()
  $("#sort_summary_num").removeClass()
  $("#sort_user_num").removeClass()
  $("#sort_Newest").addClass("no_selected")
  $("#sort_summary_num").addClass("selected")
  $("#sort_user_num").addClass("no_selected")

@set_sort_user_num_selected = ->
  $("#sort_Newest").removeClass()
  $("#sort_summary_num").removeClass()
  $("#sort_user_num").removeClass()
  $("#sort_Newest").addClass("no_selected")
  $("#sort_summary_num").addClass("no_selected")
  $("#sort_user_num").addClass("selected")

@set_focus_all_selected = ->
  $("#focus_all").removeClass()
  $("#focus_reading").removeClass()
  $("#focus_not_reading").removeClass()
  $("#focus_all").addClass("selected")
  $("#focus_reading").addClass("no_selected")
  $("#focus_not_reading").addClass("no_selected")

@set_focus_reading_selected = ->
  $("#focus_all").removeClass()
  $("#focus_reading").removeClass()
  $("#focus_not_reading").removeClass()
  $("#focus_all").addClass("no_selected")
  $("#focus_reading").addClass("selected")
  $("#focus_not_reading").addClass("no_selected")

@set_focus_not_reading_selected = ->
  $("#focus_all").removeClass()
  $("#focus_reading").removeClass()
  $("#focus_not_reading").removeClass()
  $("#focus_all").addClass("no_selected")
  $("#focus_reading").addClass("no_selected")
  $("#focus_not_reading").addClass("selected")
