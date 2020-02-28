class Admin::FechamentoController < ApplicationController
  before_filter :verificar_token
  skip_before_filter :verify_authenticity_token

  def create
    require "fechamento_mensal"
    base = DateTime.now - 1.month
    FechamentoMensal.do(params[:mes] || base.month, params[:ano] || base.year)
    InfoMailer.informar(["Fechamento Realizado com Sucesso"], "Fechamento Mensal").deliver
    render nothing: true
  rescue
    InfoMailer.informar(["#{$!}"], "Falha no Fechamento Mensal").deliver
    render nothing: true, status: 500
  end

  private

  def verificar_token
    raise "Token inválido" if params[:token].to_s != "BeotDLqkLl1E1gAtYtU4PbxLtEWHMiVgCpBtdGyBXGnjO"
  end
end