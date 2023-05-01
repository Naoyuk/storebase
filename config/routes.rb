Rails.application.routes.draw do
  root "site#index"
  devise_for :users
  get "site/index"
  get "/home", to: "site#home"
  get "/dashboard", to: "site#dashboard"
end
