// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

window.onload = load;

function toggle(id) {
  var cb = get_checkbox(id);
  cb.checked = !cb.checked;
  update(id, true);
}

function update(id, set) {
  var cb = get_checkbox(id);
  var td = document.getElementById("cell_" + id);
  td.className = cb.checked ? 'availability-yes' : 'availability-no';
  if (set) {
    enableButton("update-button", "primary");
    enableButton("cancel-button", "danger");
    enableButton("clear-all-button", "warning");
  }
}

function get_checkbox(id) {
  return document.querySelectorAll("input[type='checkbox'][value='" + id + "']")[0];
}

function load() {
  $('input[type=checkbox]').each(function(id){
    update($(this).val(), false);
  });
  $('#clear-all-button').click(function(e){
    e.preventDefault();
    $('input[type=checkbox]').each(function(id){
      $(this).prop('checked', false);
      update($(this).val(), true);
    });
    disableButton("clear-all-button");
  });
  $('#cancel-button').click(function(e){
    e.preventDefault();
    location = location;
  });
  disableButton("update-button");
  disableButton("cancel-button");
}

function disableButton(buttonName) {
  var button = document.getElementById(buttonName);
  button.className = "btn btn-large btn-light disabled";
  button.disabled = true;
}

function enableButton(buttonName, type) {
  var button = document.getElementById(buttonName);
  button.className = "btn btn-large btn-" + type;
  button.disabled = false;
}
