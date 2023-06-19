Rails.application.routes.draw do
  root "features#index"
  devise_for :users, controllers: { registrations: 'users/registrations' }

  get "site/index"
  get "/home", to: "site#home"
  get "/profile", to: "site#profile"

  resources :features do
    resources 'mappings'
  end
end
