# frozen_string_literal: true

class MasqueradesController < Devise::MasqueradesController
  def show
    super
  end

  def back
    super
  end

  protected

  def masquerade_authorize!
    authorize!(:masquerade, User) unless user_masquerade?
  end

  def after_masquerade_path_for(_resource)
    users_path
  end

  def after_back_masquerade_path_for(_resource)
    users_path
  end
end
