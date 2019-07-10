Rails.application.routes.draw do
  resources :types
  namespace :api do
    namespace :v1 do
      post 'owners', to: 'owners#register'
      resources :owners
      resources :companies
      resources :contacts
      resources :types
      resources :users, only: [:create, :index] do
        collection do
          post 'login'
          post 'confirm'
          post 'invitation'
          get 'confirm_email'
          get 'users'
        end
      end
      resources :invitations


      match '*a', to: 'base#undefined_route', via: :all
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
