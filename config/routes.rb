Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      post 'owners', to: 'owners#register'
      resources :owners
      resources :companies
      resources :contacts
      resources :types
      resources :industries
      resources :account_managers
      resources :customers
      resources :manufacturers
      resources :business_units
      resources :orders
      resources :users do#, only: [:create, :index, :delete, :update, :show] do
        collection do
          post 'login'
          post 'confirm'
          # post 'invitation'
          get 'confirm_email'
          post 'password_reset'
          get 'verify_reset_email'
          get 'password', to: 'users#verify_token'
          put 'password_update'
          # get 'users'
        end
      end
      resources :invitations


      match '*a', to: 'base#undefined_route', via: :all
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
