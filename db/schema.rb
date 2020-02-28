# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150728130835) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "banners", force: true do |t|
    t.date     "data_inicial"
    t.date     "data_final"
    t.string   "url"
    t.string   "descricao"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "user_id"
    t.string   "tipo"
  end

  add_index "banners", ["user_id"], name: "index_banners_on_user_id", using: :btree

  create_table "cities", force: true do |t|
    t.string   "description"
    t.string   "uf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "cities", ["slug"], name: "index_cities_on_slug", unique: true, using: :btree

  create_table "cities_users", id: false, force: true do |t|
    t.integer "city_id"
    t.integer "user_id"
  end

  add_index "cities_users", ["city_id"], name: "index_cities_users_on_city_id", using: :btree
  add_index "cities_users", ["user_id"], name: "index_cities_users_on_user_id", using: :btree

  create_table "config_boletos", force: true do |t|
    t.string   "banco"
    t.string   "convenio"
    t.string   "agencia"
    t.string   "conta_corrente"
    t.integer  "dias_vencimento"
    t.text     "instrucoes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "posto"
    t.string   "byte_geracao"
  end

  add_index "config_boletos", ["user_id"], name: "index_config_boletos_on_user_id", using: :btree

  create_table "config_pagseguros", force: true do |t|
    t.integer  "franquia_user_id"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "config_pagseguros", ["franquia_user_id"], name: "index_config_pagseguros_on_franquia_user_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "movimentos", force: true do |t|
    t.date     "data"
    t.decimal  "vlr",                 precision: 15, scale: 6
    t.integer  "user_id"
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transacao_id"
    t.integer  "fechamento_mes_base"
    t.integer  "fechamento_ano_base"
  end

  add_index "movimentos", ["data"], name: "index_movimentos_on_data", using: :btree
  add_index "movimentos", ["transacao_id"], name: "index_movimentos_on_transacao_id", using: :btree
  add_index "movimentos", ["user_id"], name: "index_movimentos_on_user_id", using: :btree

  create_table "operadores", force: true do |t|
    t.string   "nome"
    t.integer  "estabelecimento_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.boolean  "eliminado"
  end

  add_index "operadores", ["email"], name: "index_operadores_on_email", unique: true, using: :btree
  add_index "operadores", ["estabelecimento_user_id"], name: "index_operadores_on_estabelecimento_user_id", using: :btree

  create_table "pagamentos", force: true do |t|
    t.decimal  "valor",            precision: 15, scale: 6
    t.string   "status"
    t.integer  "origem_id"
    t.integer  "destino_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data_vencimento"
    t.string   "tipo_pagamento"
    t.string   "url_pagseguro"
    t.string   "nosso_numero"
    t.integer  "planos_adesao_id"
    t.string   "categoria"
    t.boolean  "recebido"
  end

  add_index "pagamentos", ["destino_id"], name: "index_pagamentos_on_destino_id", using: :btree
  add_index "pagamentos", ["origem_id"], name: "index_pagamentos_on_origem_id", using: :btree
  add_index "pagamentos", ["planos_adesao_id"], name: "index_pagamentos_on_planos_adesao_id", using: :btree

  create_table "parametrizacoes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "percentual_cliente"
    t.float    "percentual_franquia"
    t.float    "percentual_indicado"
    t.float    "vlr_minimo_bonus_indicacao"
    t.float    "percentual_administracao"
    t.float    "vlr_consumo_medio_para_resgate_premios"
    t.integer  "prazo_entrega_premio"
    t.float    "valor_cartao"
  end

  create_table "planos_adesoes", force: true do |t|
    t.float    "vlr_anuidade"
    t.float    "vlr_indicado"
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantidade_indicacoes"
  end

  create_table "premios", force: true do |t|
    t.integer  "tipo_usuario_id"
    t.string   "descricao"
    t.text     "descricao_completa"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "imagem_file_name"
    t.string   "imagem_content_type"
    t.integer  "imagem_file_size"
    t.datetime "imagem_updated_at"
  end

  add_index "premios", ["tipo_usuario_id"], name: "index_premios_on_tipo_usuario_id", using: :btree

  create_table "resgates", force: true do |t|
    t.integer  "cliente_user_id"
    t.integer  "premio_id"
    t.boolean  "enviado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resgates", ["cliente_user_id"], name: "index_resgates_on_cliente_user_id", using: :btree
  add_index "resgates", ["premio_id"], name: "index_resgates_on_premio_id", using: :btree

  create_table "tipo_usuarios", force: true do |t|
    t.string   "descricao"
    t.integer  "quantidade_indicacoes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "imagem_file_name"
    t.string   "imagem_content_type"
    t.integer  "imagem_file_size"
    t.datetime "imagem_updated_at"
  end

  create_table "transacoes", force: true do |t|
    t.string   "forma_pagamento"
    t.decimal  "vlr_gasto",             precision: 15, scale: 6
    t.integer  "cliente_user_id"
    t.integer  "operador_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cancelada"
    t.string   "motivo"
    t.string   "documento"
    t.decimal  "valor_franquia",        precision: 15, scale: 6
    t.decimal  "valor_padrinho",        precision: 15, scale: 6
    t.string   "tipo_pagamento"
    t.float    "percentual_bonus_real"
  end

  add_index "transacoes", ["cancelada"], name: "index_transacoes_on_cancelada", using: :btree
  add_index "transacoes", ["cliente_user_id"], name: "index_transacoes_on_cliente_user_id", using: :btree
  add_index "transacoes", ["created_at"], name: "index_transacoes_on_created_at", using: :btree
  add_index "transacoes", ["forma_pagamento"], name: "index_transacoes_on_forma_pagamento", using: :btree
  add_index "transacoes", ["operador_id"], name: "index_transacoes_on_operador_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                          default: "",    null: false
    t.string   "encrypted_password",             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "juridica_fisica"
    t.string   "cpf_cnpj"
    t.string   "nome"
    t.string   "logradouro"
    t.string   "bairro"
    t.string   "complemento"
    t.string   "numero"
    t.string   "telefone"
    t.string   "celular"
    t.string   "type"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "cep"
    t.float    "percentual_bonus_real"
    t.integer  "plano_adesao_id"
    t.integer  "cliente_user_indicador_id"
    t.string   "numero_cartao"
    t.integer  "padrinho_id"
    t.float    "taxa_publicidade"
    t.boolean  "cartao_emitido",                 default: false
    t.string   "cidade"
    t.string   "descricao"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.date     "data_nascimento"
    t.string   "estado_civil"
    t.string   "sexo"
    t.string   "url"
    t.integer  "quantidade_indicacoes"
    t.float    "percentual_bonus_outras_formas"
    t.string   "observacao"
    t.boolean  "importado",                      default: false, null: false
    t.string   "razao_social"
  end

  add_index "users", ["cliente_user_indicador_id"], name: "index_users_on_cliente_user_indicador_id", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["cpf_cnpj"], name: "index_users_on_cpf_cnpj", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nome"], name: "index_users_on_nome", using: :btree
  add_index "users", ["numero_cartao"], name: "index_users_on_numero_cartao", unique: true, using: :btree
  add_index "users", ["padrinho_id"], name: "index_users_on_padrinho_id", using: :btree
  add_index "users", ["plano_adesao_id"], name: "index_users_on_plano_adesao_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["type"], name: "index_users_on_type", using: :btree

  add_foreign_key "banners", "users", name: "banners_user_id_fk"

  add_foreign_key "cities_users", "cities", name: "cities_users_city_id_fk"
  add_foreign_key "cities_users", "users", name: "cities_users_user_id_fk"

  add_foreign_key "config_boletos", "users", name: "config_boletos_user_id_fk"

  add_foreign_key "config_pagseguros", "users", name: "config_pagseguros_franquia_user_id_fk", column: "franquia_user_id"

  add_foreign_key "movimentos", "transacoes", name: "movimentos_transacao_id_fk"
  add_foreign_key "movimentos", "users", name: "movimentos_user_id_fk"

  add_foreign_key "operadores", "users", name: "operadores_estabelecimento_user_id_fk", column: "estabelecimento_user_id"

  add_foreign_key "pagamentos", "planos_adesoes", name: "pagamentos_planos_adesao_id_fk"
  add_foreign_key "pagamentos", "users", name: "pagamentos_destino_id_fk", column: "destino_id"
  add_foreign_key "pagamentos", "users", name: "pagamentos_origem_id_fk", column: "origem_id"

  add_foreign_key "premios", "tipo_usuarios", name: "premios_tipo_usuario_id_fk"

  add_foreign_key "resgates", "premios", name: "resgates_premio_id_fk"
  add_foreign_key "resgates", "users", name: "resgates_cliente_user_id_fk", column: "cliente_user_id"

  add_foreign_key "transacoes", "operadores", name: "transacoes_operador_id_fk"
  add_foreign_key "transacoes", "users", name: "transacoes_cliente_user_id_fk", column: "cliente_user_id"

  add_foreign_key "users", "planos_adesoes", name: "users_plano_adesao_id_fk", column: "plano_adesao_id"
  add_foreign_key "users", "users", name: "users_padrinho_id_fk", column: "padrinho_id"

end
