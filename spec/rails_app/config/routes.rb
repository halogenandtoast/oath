require 'monban/constraints/signed_in'
require 'monban/constraints/signed_out'

RailsApp::Application.routes.draw do
  constraints Monban::Constraints::SignedIn.new do
    resource :constrained_to_users, only: [:show]
  end

  constraints Monban::Constraints::SignedOut.new do
    resource :constrained_to_visitors, only: [:show]
  end

  get "http_basic_auth" => "http_auth#index"

  resources :posts, only: [:index]
  resources :users, only: [:create]
  resource :failure, only: [:show]
  root to: "users#new"
  get "sign_in" => "sessions#new"
  post "sign_in" => "sessions#create"
  delete "sign_out" => "sessions#destroy"
  get "sign_up" => "users#new"
  get "invalid_sign_in" => "invalid_sessions#new"
  post "invalid_sign_in" => "invalid_sessions#create"
end
