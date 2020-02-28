$(document).ready(function() {

  $("#uf").on("change", function() {
    $(this).parents("form").submit();
  })

  $("#cidade").on("change", function() {
    $(this).parents("form").submit();
  })

})

