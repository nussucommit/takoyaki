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

  def set_start_end_dates
    @start_date = (params[:start_date] || Time.zone.today.beginning_of_week)
                  .to_date
    @end_date = @start_date.to_date + 6.days
  end
end
