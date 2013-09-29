# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
number = 1
$ ->
  $(window).bottom proximity: 0.05
  $(window).on "bottom", ->
    obj = $(this)
    unless obj.data("loading")
      obj.data "loading", true
      $('#loading-image').html "<img src='/images/loader.gif' />"
      setTimeout (->
        $('#loading-image').html ""
        console.debug "number : " + number
        url = $(location).attr('href')
        $.ajax
          url: url
          type: "GET"
          data: "number=" + number
          dataType: "script"
          success: (data) ->
            console.debug "success"
            number++
          error: (data) ->
            console.error "error"
        obj.data "loading", false
      ), 2000