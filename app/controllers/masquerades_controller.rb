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
    if user_masquerade?
      if cannot? :masquerade, User
        if params[:action] != 'back'
          raise CanCan::AccessDenied.new('You are not authorized to ' \
                                         'access this page.', :masquerade, User)
        end
      end
    else
      authorize!(:masquerade, User)
    end
  end

  def after_masquerade_path_for(_resource)
    users_path
  end

  def after_back_masquerade_path_for(_resource)
    users_path
  end
end
