Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'check' => 'application#check'
  post 'login' => 'sessions#login'

  resources :users

  resources :chatrooms, only: %i[index show create update] do
    resources :chatroom_memberships, only: %i[create destroy]
    resources :messages, only: [:create]
  end

  resources :messages, only: [:destroy]
end
