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

  def must_logged_in
    unless logged_in?
      flash[:danger] = "Login Please"
      redirect_to login_url
    end
  end

  def must_not_logged_in
    if logged_in?
      redirect_to dashboard_url
    end
  end

  def must_yourself
    if logged_in?
      if current_user.id == params[:id]
        return
      end
    end

    redirect_to(welcome_url)
  end
end