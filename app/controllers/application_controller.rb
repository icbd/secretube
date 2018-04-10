class ApplicationController < ActionController::Base
  include ::ApplicationTools
  include SessionsHelper

  protect_from_forgery with: :exception
  before_action :set_i18n_locale_from_params


  protected

  def set_i18n_locale_from_params
    locale = cookies[:locale]
    if locale
      if I18n.available_locales.map(&:to_s).include?(locale)
        I18n.locale = locale
      else
        flash.now[:notice] = "#{locale} translation is not available :("

        logger.error flash[:notie]
      end
    else
      I18n.locale = :en
    end
  end
end