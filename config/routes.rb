Rails.application.routes.draw do
  root "site#index"
  devise_for :users
end
