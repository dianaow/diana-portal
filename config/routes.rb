Rails.application.routes.draw do
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
  devise_for :users
  root to: "articles#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
