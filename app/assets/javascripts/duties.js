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

function load() {
  toggleSidebar();
}

$(document).ready(load);
