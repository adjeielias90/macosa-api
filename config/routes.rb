Rails.application.routes.draw do
  resources :types
  namespace :api do
    namespace :v1 do
      post 'owners', to: 'owners#register'
      resources :owners
      resources :companies
      resources :contacts
      resources :company_types
      resources :users, only: :create do
        collection do
          post 'login'
          post 'confirm'
          post 'invitation'
          get 'confirm_email'
        end
      end
      resources :invitations


      match '*a', to: 'base#undefined_route', via: :all
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
