Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/edit-basic-info/:id', to: 'users#edit_basic_info', as: :basic_info
  patch 'update-basic-info', to: 'users#update_basic_info'
  get 'users/:id/attendances/:date/edit', to: 'attendances#edit', as: :edit_attendances
  patch 'users/:id/attendances/:date/update', to: 'attendances#update', as: :update_attendances
  patch 'users/:id/:date/month_application', to: 'attendances#month_application', as: :month_application_attendances
  patch 'users/:id/approval_application', to: 'attendances#approval_application', as: :approval_application_attendances
  patch 'users/:id/approval_upd', to: 'attendances#approval_upd', as: :approval_upd_attendances
  get 'users/:id/confirmation/:application_id/:date', to: 'users#show_confirmation', as: :user_confirmation
  
  resources :users do
    member do
      # ユーザ情報の編集（indexページ）
      patch 'user_update'
    end
    
    resources :attendances, only: :create
    resources :attendance_logs
    collection { post :import }
  end
  get "/index/:per" => "users#index_user_list", as: :user_list
  get "/work_now", to: 'users#work_now'
  
  resources :bases
end
