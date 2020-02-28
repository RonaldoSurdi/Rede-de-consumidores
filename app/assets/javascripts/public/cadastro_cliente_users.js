$(function() {
  'use strict';

  if ($(".cadastro-pessoa-fisica-juridica").length === 0) return;
  window.cliente = {};

  cliente.init = function() {
    $("#cliente_user_juridica_fisica_f").on("change", cliente.atualizarTipoPessoa);
    $("#cliente_user_juridica_fisica_j").on("change", cliente.atualizarTipoPessoa);

    cliente.atualizarTipoPessoa();
    cliente.touched = true;
  };

  cliente.atualizarTipoPessoa = function() {
    var fisica = $("#cliente_user_juridica_fisica_f");
    var juridica = $("#cliente_user_juridica_fisica_j")
    var labelNome = $("label[for=cliente_user_nome]");
    var labelCpfCnpj = $("label[for=cliente_user_cpf_cnpj]");
    var input = $("#cliente_user_cpf_cnpj");
    var razaoSocial = $("#cliente_user_razao_social");

    if ($("#cliente_user_juridica_fisica_f").prop("checked") === true) {
      labelNome.html("Nome Completo");
      labelCpfCnpj.html("CPF");
      input.mask(window.app.masks.CPF);
      razaoSocial.removeAttr("required").parents("div.form-group").hide();

      cliente.camposAdicionais(true);
      $('#cliente_user_nome').focus();
    } else {
      labelNome.html("Nome Fantasia");
      labelCpfCnpj.html("CNPJ");

      input.mask(window.app.masks.CNPJ);
      input.val(input.attr('value'));
      input.trigger('blur');

      razaoSocial.attr("required", "required").parents("div.form-group").show();

      cliente.camposAdicionais(false);
      $('#cliente_user_nome').focus();
    }

    if (cliente.touched) {
      cliente.retirarErros(['#cliente_user_nome', '#cliente_user_cpf_cnpj']);
    }
  };

  cliente.camposAdicionais = function(ativar) {
    var camposAdicionais = $("#cliente_user_sexo, #cliente_user_estado_civil, #cliente_user_data_nascimento");
    var form = camposAdicionais.parents('form');

    if (ativar) {
      camposAdicionais.removeAttr("disabled");
      camposAdicionais.attr("required", "required");
    }
    else {
      camposAdicionais.removeAttr("required");
      camposAdicionais.attr("disabled", "disabled");
    }
  };

  cliente.retirarErros = function(inputIds) {
    var inputGroups = $(inputIds.join(', ')).parents('.form-group');
    inputGroups.children('.help-block').hide();
    inputGroups.removeClass("has-error");
  };

  cliente.init();
});

