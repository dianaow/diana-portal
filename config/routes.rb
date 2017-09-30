Rails.application.routes.draw do
  
  mount ActionCable.server => "/cable"
  
  resources :friendships, only: [:create, :update, :destroy]
  resources :categories, only: [:show, :index]
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :users, only: [:index, :show, :followers, :following] do 
    collection do 
      get 'followers'
      get 'following'
      get 'search'
    end
  end
  get 'followers', to: 'users#followers'
  get 'following', to: 'users#following'
  get 'search', to: 'users#search'
  get 'drafts', to: 'articles#drafts'
  
  resources :articles do
    resources :comments
    member do
      put :toggle_vote
    end
  end
  
  resources :notifications do
    collection do 
        post :mark_as_read
    end 
  end
  
  resources :conversations, only: [:index, :new] do
    collection do   
      get 'list'
    end
  end

  resources :conversations, only: [:create] do
    resources :messages, only: [:create]
  end

  root 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
