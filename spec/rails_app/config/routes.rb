RailsApp::Application.routes.draw do
  resources :posts, only: [:index]
  resources :users, only: [:create]
  resource :failure, only: [:show]
  root to: "users#new"
  get "sign_in" => "sessions#new"
  post "sign_in" => "sessions#create"
  delete "sign_out" => "sessions#destroy"
  get "sign_up" => "users#new"
end
