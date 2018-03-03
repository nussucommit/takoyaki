// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('turbolinks:load', function() {
  $('.close-button').click(function() {
    $('.announcement-form').trigger('reset');
  });
});