$(function() {
  periodo = {
    select: $("select#tipo_data"),
    inicial: $("#data_inicial"),
    final: $("#data_final"),

    binds: function() {
      this.select.on("change", periodo.setar);
    },

    setar: function() {
      var dataInicial = new Date();
      var dataFinal = new Date();
      var tipo = periodo.select.find(":selected").val();

      switch (tipo) {
        case '':
          dataInicial = dataFinal = null;
          break;
        case 'HOJE':
          break;
        case 'ONTEM':
          dataInicial.setDate(dataInicial.getDate() - 1);
          dataFinal.setDate(dataFinal.getDate() - 1);
          break;
        case 'SEMANA_ATUAL':
          dataInicial.setDate(dataInicial.getDate() - dataInicial.getDay());
          dataFinal.setDate(dataInicial.getDate() + 6);
          break;
        case 'SEMANA_ANTERIOR':
          dataInicial.setDate(dataInicial.getDate() - dataInicial.getDay());
          dataFinal.setDate(dataInicial.getDate() - 1);
          dataInicial.setDate(dataFinal.getDate() - 6);
          break;
        case 'MES_ANTERIOR':
          dataInicial.setDate(1);
          dataInicial.setMonth(dataInicial.getMonth() - 1);
          dataFinal = moment(dataInicial).add('months', 1).subtract('days', 1)
          break;
        case 'MES_ATUAL':
          dataInicial.setDate(1);
          dataFinal.setMonth(dataFinal.getMonth()+1, 1);
          dataFinal.setDate(dataFinal.getDate() - 1);
          break;
        case 'PROXIMO_MES':
          dataInicial = moment().date(1).add("months", 1);
          dataFinal = moment().date(1).add("months", 2).subtract("days", 1);
          break;
        case 'ULTIMOS_3_MESES':
          dataInicial.setDate(1);
          dataInicial.setMonth(dataFinal.getMonth()-2, 1);
          dataFinal.setMonth(dataFinal.getMonth()+1, 1);
          dataFinal.setDate(dataFinal.getDate() - 1);
          break;
        case 'ANO_CORRENTE':
          dataInicial.setMonth(0, 1);
          dataFinal.setMonth(11, 31);
          break;
      }

      periodo.inicial.val(moment(dataInicial).format("DD/MM/YYYY"));
      periodo.final.val(moment(dataFinal).format("DD/MM/YYYY"));
    },
    init: function() {
      periodo.binds();
    }
  }

  periodo.init();
});