Rails.application.routes.draw do
  devise_for :workers
  devise_for :companies
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
