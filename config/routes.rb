Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :owners
      resources :companies
      resources :contacts
      resources :company_types
      resources :users, only: :create do
        collection do
          post 'login'
          post 'confirm'
        end
      end
      post 'owner', to: 'owners#register'

      match '*a', to: 'base#undefined_route', via: :all
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
