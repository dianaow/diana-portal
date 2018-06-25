Rails.application.routes.draw do
  
  mount ActionCable.server => "/cable"
  
  resources :friendships, only: [:create, :update, :destroy]
  resources :categories, only: [:show, :index]
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :users, only: [:index, :show] do
    collection do   
      get 'search'
    end
  end

  get 'followers', to: 'users#followers'
  get 'following', to: 'users#following'
  get 'drafts', to: 'articles#drafts'
  
  resources :articles do
    resources :comments, only: [:create, :update, :destroy, :edit]
    member do
      get 'upvote'
      get 'downvote'
    end
  end
  
  resources :notifications, only: [:index, :destroy]
  
  resources :conversations, only: [:index, :new] do
    collection do   
      get 'list'
    end
  end

  resources :conversations, only: [:create] do
    resources :messages, only: [:create]
  end
  
  get 'refresh', to: 'pages#refresh'
  get 'follow_recommended', to: 'pages#follow_recommended'
  get 'about', to: 'pages#about'

  root 'pages#home'

  match "*path", to: "application#catch_404", via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
