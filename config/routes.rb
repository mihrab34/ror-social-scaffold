Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show]
  resources :friendships
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  # get 'friendships', to: 'friendships#index'
  post 'create_friendship', to: 'friendships#create'
  get 'accept_request', to: 'friendships#accept'
  put 'accept_request', to: 'friendships#accept'
  delete 'delete_request', to: 'friendships#reject'
  delete 'cancel_request' => 'friendships#cancel'
  delete 'remove_friend', to: 'friendships#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
