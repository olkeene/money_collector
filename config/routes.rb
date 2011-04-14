MoneyCollector::Application.routes.draw do
  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'login' => 'sessions#new', :as => :login

  resources :sessions
  resources :users

  resources :countries, :except => :destroy do
    collection do
      get :visited
    end

    member do
      post :buy_currency
    end
  end
  resources :currencies, :only => [:index, :show]
  
  root :to => "home#index"

  match ':controller(/:action(/:id(.:format)))'
end
