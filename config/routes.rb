Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'check' => 'application#check'
  post 'login' => 'sessions#login'

  resources :users
end
