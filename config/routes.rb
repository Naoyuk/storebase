Rails.application.routes.draw do
  root "site#home"

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get '/unsubscribe', to: 'users/registrations#unsubscribe'
    put '/users/:id/withdrawal', to: 'users/registrations#soft_delete', as: 'soft_delete'
  end

  devise_for :admins

  get "site/index"
  get "/home", to: "site#home"
  get "/profile", to: "site#profile"
  get "/converter", to: "features#converter" # FeatureControllerにconverterアクションを追加

  resources :features do
    member do
      post :convert # FeatureControllerのconvertアクションを追加
    end
    resources :mappings
    resources :versions, only: [:create, :edit, :update]
  end

  post '/versions/find_or_create', to: 'versions#find_or_create', as: 'find_or_create_version'

  resources :services
  resources :service_cols
  resources :service_formats
end
