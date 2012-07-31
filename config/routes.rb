Superuser::Application.routes.draw do
  
  authenticated :user do
    root :to => "tickets#index"
  end

  devise_for :users, :controllers => {:passwords => "passwords", :registrations => "registrations"} do
    root :to => "registrations#new"
    get "sign_up", :to => "registrations#new"
  end
  match 'me' => 'users#show'
  
  resources :users, :only => [:index, :show, :edit, :update] 
  resources :tickets, :only => [:index] 
  resources :passwords, :only => [:edit, :update]
  
  match 'check_in' => 'check_in#create'
  
  namespace :admin do
    resources :users, :only => [:index, :destroy, :show, :new] do
      resources :tickets
      collection do
        get '/search'
      end
    end
  end
end