# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@toggleFollowBtn = ->
  $(document).ready ->
    $("[id=unfollow-button]").hover (->
      $(this).val "unfollow"
      $(this).removeClass("btn-primary").addClass("btn-danger");
    ), ->
      $(this).val "following"
      $(this).removeClass("btn-danger").addClass("btn-primary")
