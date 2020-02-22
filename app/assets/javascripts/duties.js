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

function drawLine(startTime, endTime) {
  var line = document.getElementById("vertical_line");
  line.style.display = "none";
  var table = document.getElementById("table");
  var tableLeft = document.getElementById("tableLeft");
  var container = document.getElementById("container");
  line.style.height = (container.clientHeight) + "px";
  container.addEventListener("scroll", helper);
  var currHours;
  var currMinutes;
  setInterval(function () {
    var date = new Date();
    currHours = date.getHours();
    currMinutes = date.getMinutes();
    if (currHours < startTime || (currHours >= endTime && currMinutes > 0)) {
      line.style.display = "none";
    } else {
      helper();
    }
  }, 1000);
  function helper() {
    var currTimeInMinutes = currHours * 60 + currMinutes;
    var rightColumnWidth = table.rows[0].cells[0].offsetWidth;
    var leftColumnWidth = tableLeft.offsetWidth + 15;
    // I am so sorry for hardcoding the adjusting term, but let's just get this thing working, okay :")
    var lowTime = container.scrollLeft / rightColumnWidth * 60 + startTime * 60;
    console.log(rightColumnWidth);
    var highTime = lowTime + container.clientWidth / rightColumnWidth * 60;
    if (lowTime <= currTimeInMinutes && currTimeInMinutes <= highTime) {
      line.style.display = "block";
      line.style.left = (((currTimeInMinutes - lowTime) / 60) * rightColumnWidth) + leftColumnWidth + "px";
    } else {
      line.style.display = "none";
    }
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
  var END_TIME = 21;//I need to hard code end time because I can't find the end time in database...
  var NUM_OF_PLACES = $('#num-of-places').data('num-of-places');
  var AVERAGE_COLSPAN = $('#average-colspan').data('average-colspan');

  scrollToCurrentTime(START_TIME); //I find this mildly annoying, and when the drawLine function is properly implemented, I think we can yeet this function away
  drawLine(START_TIME, END_TIME);
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
  if ($("#grab-page-form input[type=checkbox]:checked").length > 0) {
    return true;
  } else {
    alert("Please select at least one time slot");
    return false;
  }
}

$(document).on('turbolinks:load', load);
