Rails.application.routes.draw do

  # root page, welcome new users
  root "pages#welcome", as: "welcome"

  # static pages
  get 'pages/welcome'
  get 'pages/helper'


  # users
  resources :users
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/dashboard', to: 'users#dashboard'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # containers
  resources :containers



end
