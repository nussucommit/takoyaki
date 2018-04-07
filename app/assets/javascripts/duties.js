var startTime = 8;
var scrollLeftPx = 150;
var mediumScreenSize = 768;

function setDutyTableButtons() {
  if ($(window).width() <= mediumScreenSize) {
    $('.duty-table-button').removeClass('float-sm-right');
    $('.duty-table-title').removeClass('float-left');
  }
}

function toggleSidebar() {
  $('#announcement-toggle-btn').on('click', function() {
    if ($('#announcement-sidebar').css('display') == "block") {
      $('#announcement-sidebar').css({
        display: "none"
      }).removeClass('open');

      $('#duty-table').addClass('col-md-12');

      if ( $(window).width() <= mediumScreenSize) {
        $('.duty-table-button').addClass('float-sm-right');
        $('.duty-table-title').addClass('float-left');
      }
    } else {
      $('#announcement-sidebar').fadeIn({
        duration: 200
      }).addClass('open');

      $('#duty-table').addClass('col-md-9').removeClass('col-md-12');

      if ( $(window).width() <= mediumScreenSize) {
        $('.duty-table-button').removeClass('float-sm-right');
        $('.duty-table-title').removeClass('float-left');
      }
    }
  });
}

function scrollToCurrentTime() {
  var date = new Date();
  var coeff = 1000 * 60 * 60;
  var rounded = new Date(Math.floor(date.getTime() / coeff) * coeff);
  var current_hour = rounded.getHours();
  var offset = current_hour - startTime;

  if (offset > 0) {
    $('.schedule-right').scrollLeft(scrollLeftPx * offset);
  }
}

function load() {
  scrollToCurrentTime();
  toggleSidebar();
  setDutyTableButtons();
}

$(document).on('turbolinks:load', load);
