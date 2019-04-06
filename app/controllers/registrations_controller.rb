# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # Required so that authenticated users can access this page
  # instead of being redirected to new_user_session_path
  skip_before_action :require_no_authentication

  def new
    @last_mc_value = User.order(:updated_at).last&.mc&.to_s || "false"
    ensure_admin || return
    super
  end

  def create
    ensure_admin || return
    build_resource(sign_up_params)
    resource.save
    success = resource.save
    yield resource if block_given?

    if success
      redirect_to users_path, notice: 'Created user succesfully'
    else
      redirect_to users_path,
                  alert: resource.errors.full_messages.join(',')
    end
  end

  def after_sign_up_path_for(_resource)
    users_path
  end

  def after_inactive_sign_up_path_for(_resource)
    users_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def ensure_admin
    redirect_to(new_user_session_path) && return unless user_signed_in?
    redirect_to(users_path) && return unless current_user.has_role? :admin
    true
  end
end
