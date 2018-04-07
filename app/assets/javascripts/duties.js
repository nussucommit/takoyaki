var startTime = 8;
var scrollLeftPx = 150;

function toggleSidebar() {
  $('#announcement-toggle-btn').on('click', function() {
    if ($('#announcement-sidebar').css('display') == "block") {
      $('#announcement-sidebar').css({
        display: "none"
      }).removeClass('open');

      $('#duty-table').addClass('col-md-12');
    } else {
      $('#announcement-sidebar').fadeIn({
        duration: 200
      }).addClass('open');

      $('#duty-table').addClass('col-md-9').removeClass('col-md-12');
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
}

$(document).on('turbolinks:load', load);
