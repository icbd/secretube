Rails.application.routes.draw do
  root "pages#welcome", as: "welcome"

  get 'pages/welcome'

  get 'pages/helper'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
