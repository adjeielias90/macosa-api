Rails.application.routes.draw do


  namespace :api do
    namespace :v1 do
      resources :owners do
        post 'login'
      end
      resources :companies
      resources :contacts
      post 'owner/register', to: 'owners#register'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
