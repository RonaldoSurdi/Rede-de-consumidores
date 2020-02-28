$(function() {
  if (typeof(window.app) === "undefined") {
    window.app = {};
  }

  window.app.masks = {
    CPF: "999.999.999-99",
    CNPJ: "99.999.999/9999-99",
    CEP: "99999-999",
    DATA: "99/99/9999",
    TELEFONE: "(99) 9999-9999",
    TELEFONE8: "(99) 9999-9999",
    CARTAO: "9 999 999 999"
  }

  $("input[data-monetario]").priceFormat({
    prefix: 'R$ ',
    centsSeparator: ',',
    thousandsSeparator: '.',
    centsLimit: 2
  });

  $("input[data-percentual]").priceFormat({
    prefix: '',
    suffix: '',
    centsSeparator: ',',
    thousandsSeparator: '.',
    centsLimit: 2
  });

  $("input[data-mask=cep]").mask(app.masks.CEP);
  $("input[data-mask=data]").mask(app.masks.DATA);
  $("input[data-mask=telefone]").mask(app.masks.TELEFONE);
  $("input[data-mask=telefone8]").mask(app.masks.TELEFONE8);
  $("input[data-mask=cpf]").mask(app.masks.CPF);
  $("input[data-mask=cnpj]").mask(app.masks.CNPJ);
  $("input[data-mask=cartao]").mask(app.masks.CARTAO);
  if (typeof($.datepicker) !== "undefined") {
    $("input[data-mask=data]").mask(app.masks.DATA).datepicker({
      format: "dd/mm/yyyy",
      language: "pt-BR",
    });
  }


  $("[data-toggle=tooltip]").on("click", function(e) {
    e.preventDefault();
  }).tooltip();
});