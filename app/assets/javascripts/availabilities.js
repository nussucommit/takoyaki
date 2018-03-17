// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

window.onload = load;

function toggle(id) {
  var cb = getCheckbox(id);
  cb.checked = !cb.checked;
  updateCheckbox(id, true);
}

function updateCheckbox(id, set) {
  var cb = getCheckbox(id);
  var td = document.getElementById("cell_" + id);
  td.className = cb.checked ? 'availability-yes' : 'availability-no';
  if (set) {
    enableButton("update-button", "primary");
    enableButton("cancel-button", "danger");
    enableButton("clear-all-button", "warning white-text");
  }
}

function getCheckbox(id) {
  return document.querySelectorAll("input[type='checkbox'][value='" + id + "']")[0];
}

function load() {
  $('input[type=checkbox]').each(function(id) {
    updateCheckbox($(this).val(), false);
  });
  $('#clear-all-button').click(function(e){
    e.preventDefault();
    $('input[type=checkbox]').each(function(id) {
      $(this).prop('checked', false);
      updateCheckbox($(this).val(), true);
    });
    disableButton("clear-all-button");
  });
  $('#cancel-button').click(function(e) {
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
