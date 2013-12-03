# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@toggleUnfollowBtn = ->
  $(document).ready ->
    $("[id=unfollow-button]").hover (->
      $(this).val I18n.t('follow.cancel')
      $(this).removeClass("btn-primary").addClass("btn-danger");
    ), ->
      $(this).val I18n.t('follow.is_true')
      $(this).removeClass("btn-danger").addClass("btn-primary")
