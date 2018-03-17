// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

window.onload = load;

function toggle(id) {
  var cb = get_checkbox(id);
  cb.checked = !cb.checked;
  update(id);
}

function update(id) {
  var cb = get_checkbox(id);
  var td = document.getElementById("cell_" + id);
  td.className = cb.checked ? 'availability-yes' : 'availability-no';
}

function get_checkbox(id) {
  return document.querySelectorAll("input[type='checkbox'][value='" + id + "']")[0];
}

function load() {
  $('input[type=checkbox]').each(function(id){
    update($(this).val());
  });
  $('#clear-all-button').click(function(e){
    e.preventDefault();
    $('input[type=checkbox]').each(function(id){
      $(this).prop('checked', false);
      update($(this).val());
    });
  });
  $('#cancel-button').click(function(e){
    e.preventDefault();
    location = location;
  });
}
