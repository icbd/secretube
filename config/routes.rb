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


end
