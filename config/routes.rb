Rails.application.routes.draw do
  get 'users/create'
  get 'users/new'
  get 'sign_up', to: "users#new"
  post 'sign_up', to: "users#create"
  resources :book_quotes
  root to: 'book_quotes#index'
  resources :users, only: [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
