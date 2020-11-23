Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show]
  resources :friendships
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  post 'create_friendship', to: 'friendships#create'
  patch 'accept_request', to: 'friendships#accept'
  delete 'delete_request', to: 'friendships#destroy'
  delete 'cancel_request', to: 'friendships#reject'
  delete 'remove_friend', to: 'friendships#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
