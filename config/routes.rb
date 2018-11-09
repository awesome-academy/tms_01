Rails.application.routes.draw do
  root "static_pages#home"
  
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users
  resources :courses do
    collection do
      get :add_member
      get :add_subject
      delete :delete_member
      delete :delete_subject   
    end
    member do
      get :member_remaining
      get :subject_remaining
    end
  end
  resources :subjects

  namespace :basic_trainee do
    resources :users
  end
end
