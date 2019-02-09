# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  rescue_from CanCan::AccessDenied, with: :access_denied

  protected

  def configure_permitted_parameters
    added_attrs = %i[username matric_num contact_num email password
                     password_confirmation remember_me mc cell]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def access_denied(exception)
    store_location_for :user, request.path
    redirect_to(user_signed_in? ? root_path : new_user_session_path,
                alert: exception.message)
  end
end
