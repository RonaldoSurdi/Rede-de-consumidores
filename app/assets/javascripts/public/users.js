$(function() {
  $("#cliente_user_cep").on("change", function() {
    loader.show();
    $("form#new_cliente_user *").attr("disabled", true);
    $.ajax({
      url: app.urlCep.replace("-1", $(this).val()),
      type: "GET",
      complete: function() {
        loader.hide();
        $("form#new_cliente_user *").removeAttr("disabled");
        if ($("#cliente_user_cidade").val() !== "") {
          $("#cliente_user_logradouro").focus();
        } else {
          $("#cliente_user_cep").focus();
        }
      }
    });
  });

  $("#new-cadastro form").on("submit", function(e) {
    if (!$(this).data("confirmado")) {
      var modal = $("#modal-confirmacao-cadastro");
      modal.find("#nome").text($("#cliente_user_nome").val());
      modal.find("#indicacao").text($("#nome-indicacor").text());
      modal.modal("show");
      e.preventDefault();
    }
  });

  $("#modal-confirmacao-cadastro #confirmar-cadastro").on("click", function() {
    $("#new-cadastro form").data("confirmado", true).submit();
  });
});