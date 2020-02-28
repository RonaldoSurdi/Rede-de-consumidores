$(function() {
  $("#franquia_user_city_ids").bootstrapDualListbox({
      nonselectedlistlabel: 'Cidades',
      selectedlistlabel: 'Cidades Selecionadas',
      preserveselectiononmove: 'moved',
      moveonselect: false,
      infotext: "Listando Todos {0}",
      infotextempty: "Lista Vazia",
      filterplaceholder: "Filtro",
      filtertextclear: "Mostrar Todos",
      infotextfiltered: "Exibindo {0} de {1}",
      helperselectnamepostfix: false
  });

  var prefix = $("body").hasClass("franquia_users") ? "franquia" : "estabelecimento";

  $("#" + prefix + "_user_juridica_fisica_f").on("change", function() {
    updateTipoPessoa();
  });

  $("#" + prefix + "_user_juridica_fisica_j").on("change", function() {
    updateTipoPessoa();
  });

  updateTipoPessoa();

  function updateTipoPessoa() {
    var fisica = $("#" + prefix + "_user_juridica_fisica_f");
    var juridica = $("#" + prefix + "_user_juridica_fisica_j")
    var label = $("label[for=" + prefix + "_user_cpf_cnpj]");
    var input = $("#" + prefix + "_user_cpf_cnpj");
    if (juridica.is(":checked")) {
      label.html("CNPJ");
      input.mask(app.masks.CNPJ);
    } else {
      label.html("CPF");
      input.mask(app.masks.CPF);
    }
  }
});