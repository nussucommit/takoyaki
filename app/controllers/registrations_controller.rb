# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication

  def create
    # super
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    redirect_to users_path
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
end
