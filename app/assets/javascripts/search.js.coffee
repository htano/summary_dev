# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#condition_tag").click ->
    $("#condition_tag").removeClass()
    $("#condition_title").removeClass()
    $("#condition_content").removeClass()
    $("#condition_tag").addClass("selected")
    $("#condition_title").addClass("no_selected")
    $("#condition_content").addClass("no_selected")
    $("#condition").val(1)

$ ->
  $("#condition_title").click ->
    $("#condition_tag").removeClass()
    $("#condition_title").removeClass()
    $("#condition_content").removeClass()
    $("#condition_tag").addClass("no_selected")
    $("#condition_title").addClass("selected")
    $("#condition_content").addClass("no_selected")
    $("#condition").val(2)

$ ->
  $("#condition_content").click ->
    $("#condition_tag").removeClass()
    $("#condition_title").removeClass()
    $("#condition_content").removeClass()
    $("#condition_tag").addClass("no_selected")
    $("#condition_title").addClass("no_selected")
    $("#condition_content").addClass("selected")
    $("#condition").val(3)

$ ->
  $("#sort_recent").click ->
    $("#sort_recent").removeClass()
    $("#sort_summary_num").removeClass()
    $("#sort_recent").addClass("selected")
    $("#sort_summary_num").addClass("no_selected")
    $("#sort").val(1)

$ ->
  $("#sort_summary_num").click ->
    $("#sort_recent").removeClass()
    $("#sort_summary_num").removeClass()
    $("#sort_recent").addClass("no_selected")
    $("#sort_summary_num").addClass("selected")
    $("#sort").val(2)

$ ->
  $("#focus_all").click ->
    $("#focus_all").removeClass()
    $("#focus_added_only").removeClass()
    $("#focus_without_added").removeClass()
    $("#focus_all").addClass("selected")
    $("#focus_added_only").addClass("no_selected")
    $("#focus_without_added").addClass("no_selected")
    $("#focus").val(1)

$ ->
  $("#focus_added_only").click ->
    $("#focus_all").removeClass()
    $("#focus_added_only").removeClass()
    $("#focus_without_added").removeClass()
    $("#focus_all").addClass("no_selected")
    $("#focus_added_only").addClass("selected")
    $("#focus_without_added").addClass("no_selected")
    $("#focus").val(2)

$ ->
  $("#focus_without_added").click ->
    $("#focus_all").removeClass()
    $("#focus_added_only").removeClass()
    $("#focus_without_added").removeClass()
    $("#focus_all").addClass("no_selected")
    $("#focus_added_only").addClass("no_selected")
    $("#focus_without_added").addClass("selected")
    $("#focus").val(3)
