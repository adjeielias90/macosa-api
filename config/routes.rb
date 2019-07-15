Rails.application.routes.draw do
  resources :types
  namespace :api do
    namespace :v1 do
      post 'owners', to: 'owners#register'
      resources :owners
      resources :companies
      resources :contacts
      resources :types
      resources :users do#, only: [:create, :index, :delete, :update, :show] do
        collection do
          post 'login'
          post 'confirm'
          # post 'invitation'
          get 'confirm_email'
          post 'password', :to 'users#send_password_reset_instructions'
          get 'verify_email', :to 'users#verify_reset_email'
          get 'password', :to 'users#verify_token'
          patch 'update_password'
          # get 'users'
        end
      end
      resources :invitations


      match '*a', to: 'base#undefined_route', via: :all
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
