Rails.application.routes.draw do
  root "features#index"

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get '/unsubscribe', to: 'users/registrations#unsubscribe'
    put '/users/:id/withdrawal', to: 'users/registrations#soft_delete', as: 'soft_delete'
  end

  get "site/index"
  get "/home", to: "site#home"
  get "/profile", to: "site#profile"
  get "/converter", to: "features#converter" # FeatureControllerにconverterアクションを追加

  resources :features do
    member do
      post :convert # FeatureControllerのconvertアクションを追加
    end
    resources 'mappings'
  end
end
