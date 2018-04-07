var ONE_HOUR_TO_MILLISECONDS = 1000 * 60 * 60;
var START_TIME = 8;
var SCROLL_LEFT_PX = 150;
var MEDIUM_SCREEN_SIZE = 768;

function setDutyTableButtons() {
  if ($(window).width() <= mediumScreenSize) {
    $('.duty-table-button').removeClass('float-sm-right');
    $('.duty-table-title').removeClass('float-left');
  }
}

function toggleSidebar() {
  $('#announcement-toggle-btn').on('click', function() {
    if ($('#announcement-sidebar').css('display') == "block") {
      $('#announcement-sidebar').hide().removeClass('open');

      $('#duty-table').addClass('col-md-12');

      if ( $(window).width() <= MEDIUM_SCREEN_SIZE) {
        $('.duty-table-button').addClass('float-sm-right');
        $('.duty-table-title').addClass('float-left');
      }
    } else {
      $('#announcement-sidebar').fadeIn({
        duration: 200
      }).addClass('open');

      $('#duty-table').addClass('col-md-9').removeClass('col-md-12');

      if ( $(window).width() <= MEDIUM_SCREEN_SIZE) {
        $('.duty-table-button').removeClass('float-sm-right');
        $('.duty-table-title').removeClass('float-left');
      }
    }
  });
}

function scrollToCurrentTime() {
  var date = new Date();
  var rounded = new Date(Math.floor(date.getTime() / ONE_HOUR_TO_MILLISECONDS) * ONE_HOUR_TO_MILLISECONDS);
  var current_hour = rounded.getHours();
  var offset = current_hour - START_TIME;

  if (offset > 0) {
    $('.schedule-right').scrollLeft(SCROLL_LEFT_PX * offset);
  }
}

function load() {
  scrollToCurrentTime();
  toggleSidebar();
  setDutyTableButtons();
}

$(document).on('turbolinks:load', load);
