Rails.application.routes.draw do
  
  resources :friendships, only: [:create, :update, :destroy]
  
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :users, only: [:index, :show]
  
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
  
  root to: "articles#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
