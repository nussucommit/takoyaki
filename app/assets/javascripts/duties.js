var ONE_HOUR_TO_MILLISECONDS = 1000 * 60 * 60;
var SCROLL_LEFT_PX = 150;
var MEDIUM_SCREEN_SIZE = 768;
var BACKGROUND_COLOR = "#f6e1af";

function setDutyTableButtons() {
  if ($(window).width() <= MEDIUM_SCREEN_SIZE) {
    $('.duty-table-button').removeClass('float-sm-right');
    $('.duty-table-title').removeClass('float-left');
  }
}

function toggleSidebar() {
  $('#announcement-toggle-btn').on('click', function() {
    if ($('#announcement-sidebar').css('display') == "block") {
      $('#announcement-sidebar').hide().removeClass('open');

      $('#duty-table').addClass('col-md-12');
    } else {
      $('#announcement-sidebar').fadeIn('fast').addClass('open');

      $('#duty-table').addClass('col-md-9').removeClass('col-md-12');
    }
  });
}

function scrollToCurrentTime(startTime) {
  var date = new Date();
  var rounded = new Date(Math.floor(date.getTime() / ONE_HOUR_TO_MILLISECONDS) * ONE_HOUR_TO_MILLISECONDS);
  var currentHour = rounded.getHours();
  var offset = currentHour - startTime;

  if (offset > 0) {
    $('.schedule-right').scrollLeft(SCROLL_LEFT_PX * offset);
  }
}

function colourScheduleTable(numOfPlaces) {
  var nthChildInt = numOfPlaces * 2;

  for (offset = 0; offset < numOfPlaces; offset++) {
    $('.schedule-container tr:nth-child(' + nthChildInt + 'n -' + offset + ')').css({
      "background-color": BACKGROUND_COLOR
    });
  }
}

function setDutyTableWidth(averageColspan) {
  if (averageColspan !== undefined) {
    $('.schedule-timings').css({ width: 150 - 5 * averageColspan });
  }
}

function load() {
  var START_TIME = $('#duty-start-time').data('start-time');
  var NUM_OF_PLACES = $('#num-of-places').data('num-of-places');
  var AVERAGE_COLSPAN = $('#average-colspan').data('average-colspan');

  scrollToCurrentTime(START_TIME);
  toggleSidebar();
  setDutyTableButtons();
  colourScheduleTable(NUM_OF_PLACES);
  setDutyTableWidth(AVERAGE_COLSPAN);
}

$(document).on('turbolinks:load', load);
