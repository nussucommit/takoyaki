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

function sidebarOnLoad() {
  checkSidebarStateExpiry();
  var currSbStateStr = sessionStorage.getItem("sidebarState");
  if (currSbStateStr) {
    $('#announcement-sidebar').hide().removeClass('open');

    $('#duty-table').addClass('col-md-12');
  } else {
    $('#announcement-sidebar').fadeIn('fast').addClass('open');

    $('#duty-table').addClass('col-md-9').removeClass('col-md-12');
  }
}

function checkSidebarStateExpiry() {
  var currSbStateStr = sessionStorage.getItem("sidebarState");
  if (currSbStateStr) {
    var currSbState = JSON.parse(currSbStateStr);
    if (Date.now() > currSbState.expiry) {
      sessionStorage.removeItem("sidebarState");
    }
  }
}

function toggleSidebar() {
  $('#announcement-toggle-btn').on('click', function () {
    if ($('#announcement-sidebar').css('display') == "block") {
      $('#announcement-sidebar').hide().removeClass('open');

      $('#duty-table').addClass('col-md-12');
      var sidebarExpiry = new Date(Date.now());
      sidebarExpiry.setHours(sidebarExpiry.getHours() + 1);
      var sidebarState = {
        state: "hide",
        expiry: sidebarExpiry
      };
      sessionStorage.setItem("sidebarState", JSON.stringify(sidebarState));
    } else {
      $('#announcement-sidebar').fadeIn('fast').addClass('open');

      $('#duty-table').addClass('col-md-9').removeClass('col-md-12');
      sessionStorage.removeItem("sidebarState");
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
    $('.schedule-timings').css({
      width: 150 - 5 * averageColspan
    });
  }
}

function load() {
  var START_TIME = $('#duty-start-time').data('start-time');
  var NUM_OF_PLACES = $('#num-of-places').data('num-of-places');
  var AVERAGE_COLSPAN = $('#average-colspan').data('average-colspan');

  scrollToCurrentTime(START_TIME);
  toggleSidebar();
  sidebarOnLoad();
  setDutyTableButtons();
  colourScheduleTable(NUM_OF_PLACES);
  setDutyTableWidth(AVERAGE_COLSPAN);
}

function validateModal() {
  if ($("#grab-drop-modal input[type=checkbox]:checked").length > 0) {
    return true;
  } else {
    alert("Please select at least one time slot");
    return false;
  }
}

function validateGrabPage() {
  // for non-MCs, make sure duty grabbed does not result in more than 6 consecutive hrs
  if (isMoreThanSixConsecutiveHours(user)) {
    alert("You cannot grab duties for more than 6 consecutive hours");
    return false;
  }
  
  // make sure at least one checkbox is checked
  if (!$("#grab-page-form input[type=checkbox]:checked").length > 0) {
    alert("Please select at least one time slot");
    return false;
  } 

  return true;
}

function isMoreThanSixConsecutiveHours(user) {

}

$(document).on('turbolinks:load', load);
