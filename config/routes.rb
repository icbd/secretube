Rails.application.routes.draw do
  # I18n locale
  scope '(:locale)' do

    root "pages#welcome", as: "welcome"

    get 'pages/welcome'

    get 'pages/helper'

  end
end
