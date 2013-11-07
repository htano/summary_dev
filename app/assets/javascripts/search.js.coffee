# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

BLANK = ''

@checkSearchtext_search = ->
  if $("#searchtext").val() == BLANK
    return false

@hide_navbar_text = ->
  $("#searchtext_nav").hide 10
  $("#search_nav").hide 10

@set_option_area = ->
  target = $("#target").val()
  type = $("#type").val()
  category = $("#category").val()
  switch target
    when "1"
      set_target_article_selected()
      $(".type_area").show 10
      $(".category_area").show 10
    when "2"
      set_target_user_selected()
      $(".type_area").hide 10
      $(".category_area").hide 10

  switch type
    when "1"
      set_type_content_selected()
    when "2"
      set_type_tag_selected()
    when "3"
      set_type_domain_selected()

  switch category
    when "0"
      set_category_all_selected()
    when "1"
      set_category_economics_selected()
    when "2"
      set_category_entertainment_selected()
    when "3"
      set_category_fun_selected()
    when "4"
      set_category_it_selected()
    when "5"
      set_category_knowledge_selected()
    when "6"
      set_category_life_selected()
    when "7"
      set_category_social_selected()
    when "8"
      set_category_other_selected()

###
jQuery(document).on "click", ".btn-info", ->
    $(this).parent().parent().parent().parent().parent().removeClass()
    $(this).parent().parent().parent().parent().parent().addClass("user_contents_follow")

jQuery(document).on "click", ".btn-danger", ->
    $(this).parent().parent().parent().parent().parent().removeClass()
    $(this).parent().parent().parent().parent().parent().addClass("user_contents_not_follow")
###
$ ->
  $("#target_article").click ->
    $(".type_area").show 10
    $(".category_area").show 10
    set_target_article_selected()
    $("#target").val(1)
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#target_user").click ->
    $(".type_area").hide 10
    $(".category_area").hide 10
    set_target_user_selected()
    $("#target").val(2)
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

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
  $("#category_all").click ->
    $("#category").val(0)
    set_category_all_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_economics").click ->
    $("#category").val(1)
    set_category_economics_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_entertainment").click ->
    $("#category").val(2)
    set_category_entertainment_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_fun").click ->
    $("#category").val(3)
    set_category_fun_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_it").click ->
    $("#category").val(4)
    set_category_it_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_knowledge").click ->
    $("#category").val(5)
    set_category_knowledge_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_life").click ->
    $("#category").val(6)
    set_category_life_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_social").click ->
    $("#category").val(7)
    set_category_social_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#category_other").click ->
    $("#category").val(8)
    set_category_other_selected()
    unless $("#searchtext").val() == BLANK
      $("#search_form").submit()

$ ->
  $("#not_read_only").click ->
    isChecked = $("#not_read_only:checked").val()
    if isChecked
      $(".article_contents").hide 10
    else
      $(".article_contents").show 10

$ ->
  $("#not_follow_only").click ->
    isChecked = $("#not_follow_only:checked").val()
    if isChecked
      $(".user_contents_follow").hide 10
    else
      $(".user_contents_follow").show 10

@set_target_article_selected = ->
  $("#target_article").removeClass()
  $("#target_user").removeClass()
  $("#target_article").addClass("selected")
  $("#target_user").addClass("not_selected")
  $("#search_form").attr("action","search_article");

@set_target_user_selected = ->
  $("#target_article").removeClass()
  $("#target_user").removeClass()
  $("#target_article").addClass("not_selected")
  $("#target_user").addClass("selected")
  $("#search_form").attr("action","search_user");

@set_type_content_selected = ->
  $("#type_content").removeClass()
  $("#type_tag").removeClass()
  $("#type_domain").removeClass()
  $("#type_content").addClass("selected")
  $("#type_tag").addClass("not_selected")
  $("#type_domain").addClass("not_selected")

@set_type_tag_selected = ->
  $("#type_content").removeClass()
  $("#type_tag").removeClass()
  $("#type_domain").removeClass()
  $("#type_content").addClass("not_selected")
  $("#type_tag").addClass("selected")
  $("#type_domain").addClass("not_selected")

@set_type_domain_selected = ->
  $("#type_content").removeClass()
  $("#type_tag").removeClass()
  $("#type_domain").removeClass()
  $("#type_content").addClass("not_selected")
  $("#type_tag").addClass("not_selected")
  $("#type_domain").addClass("selected")

@set_category_all_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("not_selected")

@set_category_economics_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("not_selected")

@set_category_entertainment_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("not_selected")

@set_category_fun_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("not_selected")

@set_category_it_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("not_selected")

@set_category_knowledge_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("not_selected")

@set_category_life_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("not_selected")

@set_category_social_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("selected")
  $("#category_other").addClass("not_selected")

@set_category_other_selected = ->
  $("#category_all").removeClass()
  $("#category_economics").removeClass()
  $("#category_entertainment").removeClass()
  $("#category_fun").removeClass()
  $("#category_it").removeClass()
  $("#category_knowledge").removeClass()
  $("#category_life").removeClass()
  $("#category_social").removeClass()
  $("#category_other").removeClass()
  $("#category_all").addClass("not_selected")
  $("#category_economics").addClass("not_selected")
  $("#category_entertainment").addClass("not_selected")
  $("#category_fun").addClass("not_selected")
  $("#category_it").addClass("not_selected")
  $("#category_knowledge").addClass("not_selected")
  $("#category_life").addClass("not_selected")
  $("#category_social").addClass("not_selected")
  $("#category_other").addClass("selected")