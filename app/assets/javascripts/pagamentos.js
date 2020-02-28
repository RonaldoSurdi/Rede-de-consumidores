$(function() {
  $("#link-enviar-boleto").on("ajax:success", function() {
    alert("Email Enviado com Sucesso");
  }).on("ajax:error", function() {
    alert("Falha ao enviar Email");
  });
});