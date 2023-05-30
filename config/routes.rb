Rails.application.routes.draw do
  get 'features/index'
  root "site#dashboard"
  devise_for :users
  get "site/index"
  get "/home", to: "site#home"
  get "/dashboard", to: "site#dashboard"
end
