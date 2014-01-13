$(document).ready(function() {
  if ($("#flash").length > 0) {
    // Hide the flash in a few seconds
    setTimeout(function() {
      $("#flash").remove()
    }, 3000)
  }
});
