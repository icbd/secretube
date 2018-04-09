Rails.application.routes.draw do
  # I18n locale
  scope '(:locale)' do

    # root page, welcome new users
    root "pages#welcome", as: "welcome"

    # static pages
    get 'pages/welcome'
    get 'pages/helper'

    # users
    get '/signup', to: 'users#new'

  end
end
