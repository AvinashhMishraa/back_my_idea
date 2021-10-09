class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :initialize_session
  before_action :load_cart

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

    def initialize_session
      session[:cart] ||= [] # empty cart = empty array
    end

    def load_cart
      @cart = Project.find(session[:cart])
    end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

end
