Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get "/users/:per" => "users#user_list_page", as: :user_list_page
  resources :users
end
