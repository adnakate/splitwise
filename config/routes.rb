Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index]
      resources :expenses, only: [:create]
      resources :payments, only: [:create]
    end
  end
end
