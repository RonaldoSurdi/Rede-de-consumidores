Consumercard::Application.routes.draw do

  scope :e, module: "e" do
    devise_for :operadores, controllers: {
      sessions: "e/sessions"
    }
    resources :transacoes, except: [:edit] do
      collection do
        get :find_cliente, as: :find_cliente
      end
      member do
        get :cancelar
      end
    end
    get "/keep_alive", controller: :transacoes, action: :keep_alive, as: :keep_alive
    root :to => redirect("/e/operadores/sign_in"), as: :operador_root
  end

  scope :admin, module: "admin" do
    resources :admin_users
    resources :franquia_users
    resources :estabelecimento_users
    resources :cities
    resources :parametrizacoes, except: [:destroy]
    resources :config_boletos, except: [:destroy] do
      get :test, on: :collection
    end
    resources :config_pagseguros, except: [:destroy]
    resources :pagamentos do
      put :confirmar, on: :member
    end
    resources :cliente_users do
      member do
        get :emitir_cartao
      end
    end
    resources :operadores
    resources :planos_adesao, except: [:new, :create, :destroy]
    resources :movimentos, only: [:index]
    resources :transacoes, only: [:index, :destroy], as: :admin_transacoes do
      member do
        get :cancelar
      end
    end
    resources :boletos, only: [:show] do
      member do
        get :enviar_email
      end
    end

    resources :auditoria, only: :show
    resources :banners
    resources :anuidades, only: [:index, :create]
    resources :indicacoes_admin, only: [:index]
    resources :tipo_usuarios
    resources :premios
    resources :resgates, only: [:index, :edit, :update], as: :resgate_admin

    devise_for :users, controllers: {
      sessions: "admin/sessions",
      passwords: "admin/passwords"
    }

    resources :password, only: [:index, :update]
    resources :fechamento, only: [:create]
    resources :importacoes, only: [:new, :create]

    root :to => 'home#index', as: :user_root
  end

  devise_for :cliente_users, controllers: {
    registrations: "cliente_user_registrations"
  }

  resources :cliente_users, only: :index, as: :painel_cliente


  resources :home, only: [:index, :create] do
   get :carregar_cidades,  on: :collection
   get :delete_cidade_default, on: :collection
  end

  resources :inicio, only: [:index]
  resources :participar, only: [:index]
  resources :conveniadas, only: [:index]
  resources :contato, only: [:index, :create]
  resources :sobre, only: [:index, :create]
  resources :premiacoes, only: [:index, :show]
  resources :privacidade, only: [:index]
  resources :resgates, only: [:index, :create] do
    get :new, on: :member, as: :new
  end
  resources :sobre, only: [:index]
  resources :estimativa_ganhos, only: [:index]
  resources :anuidades, only: [:index, :create, :new, :show], as: :public_anuidade
  resources :transacoes, only: [:index], as: :public_transacoes
  resources :conta_corrente, only: [:index]
  resources :indicacoes, only: [:new, :create]
  resources :termo_cadastro, only: [:new, :create, :destroy]
  resources :cep, only: [:show]
  resources :cartoes, only: [:index, :create]

  if Rails.env.production?
    get "/404", :to => "errors#not_found"
    get "/422", :to => "errors#unacceptable"
    get "/500", :to => "errors#internal_error"
  end

  root :to => 'home#index'
end