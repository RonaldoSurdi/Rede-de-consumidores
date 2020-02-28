$(function() {
  if (!$("body").hasClass("transacoes")) return;

  var input = $("#transacao_cliente_user_numero_cartao");
  input.on("change", function() {
    $("input#cliente").val("Carregando...");
    $.get(app.findClientesPath + "?q=" + $(this).val());
  });

  setTimeout(function() {
    $('#mensagens').fadeOut();
  }, 2000);

  var modal = $("#confirmacao-transacao");
  var form = $("#new_transacao");

  form.on("submit", function(evt) {
    if (!modal.is(":visible")) {
      popularModal();
      modal.modal();
      evt.preventDefault();
    }
  });

  $("#confirmar-button").on("click", function() {
    $("#confirmacao_senha").val(modal.find("#password").val());
    form.submit();
  });

  $("#corrigir-button").on("click", function() {
    $("input[autofocus]").focus();
  });

  $("#transacao_forma_pagamento").on("change", function() {
    var tipoPagamento = $("#transacao_tipo_pagamento");
    if ($(this).val() === "pontos") {
      tipoPagamento.attr("disabled", true).parents(".form-group").hide();
    } else {
      tipoPagamento.attr("disabled", false).parents(".form-group").show();
    }
  });
  $("#transacao_forma_pagamento").trigger("change");

  function popularModal() {
    var body = modal.find(".modal-body").html("");
    $("<p>").html("<strong>Tipo de Transação:</strong> " + $("#transacao_forma_pagamento").find(":selected").text()).appendTo(body);
    $("<p>").html("<strong>Forma de Pagamento:</strong> " + $("#transacao_tipo_pagamento").find(":selected").text()).appendTo(body);
    $("<p>").html("<strong>Cliente:</strong> " + $("#transacao_cliente_user_numero_cartao").val() + " - " + $("#cliente").val()).appendTo(body);
    $("<p>").html("<strong>Documento:</strong> " + $("#transacao_documento").val()).appendTo(body);
    $("<p>").html("<strong>Valor:</strong> " + $("#transacao_vlr_gasto").val()).appendTo(body);

    if ($("#transacao_forma_pagamento").find(":selected").val() === 'pontos') {
      $("<label>").attr("for", "password").text("Senha").addClass("control-label").appendTo(body);
      $("<input>").attr("type", "password").attr("name", "password").attr("id", "password").addClass("form-control").appendTo(body);
    }
  }

  modal.on("shown.bs.modal", function() {
    $("[name=password]").focus();
  });

  modal.on("keyup", "#password", function(e) {
     if (e.keyCode == 13) {
      $("#confirmar-button").click();
     }
  });

  $(document).on("shown.bs.modal", "#modal", function(e, data) {
    $(this).find("#motivo").focus();
  });

  $(document).on("ajax:success", "a[data-cancelar]", function(e, data) {
    $("#modal").html(data).find(".modal:eq(0)").modal();
  });

  $("[name=tipo-informacao]").on("change", function() {
    $("#transacao_cliente_user_numero_cartao").mask($(this).val() == "cpf" ? app.masks.CPF : app.masks.CARTAO);
  });

  $("input[data-enter-to-tab]").on("keypress", function(e) {
    var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
    if(key == 13) {
      e.preventDefault();
      $("#transacao_documento").focus();
    }
  });
});