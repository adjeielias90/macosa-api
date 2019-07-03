Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :owners
      resources :companies
      resources :contacts
      resources :company_types
      resources :users, only: :create
      post 'owner', to: 'owners#register'

      match '*a', to: 'base#undefined_route', via: :all
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
