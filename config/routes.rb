Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show] do
    resources :friendships
  end
  #esources :friendships
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  get 'friendships', to: 'friendships#index'
  patch 'friendships', to: 'friendships#accept', as: 'accept'
  delete 'friendships', to: 'friendships#destroy', as: 'reject'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
