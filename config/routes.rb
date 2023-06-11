Rails.application.routes.draw do
  root "site#dashboard"
  devise_for :users, controllers: { registrations: 'users/registrations' }

  get "site/index"
  get "/home", to: "site#home"
  get "/profile", to: "site#profile"
  get "/dashboard", to: "site#dashboard"

  resources :features do
    resources 'mappings'
  end
end
