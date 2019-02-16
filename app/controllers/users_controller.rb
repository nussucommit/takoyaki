# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.order(username: :asc)
    @start_date = (params[:start_date] || Time.zone.today.beginning_of_week)
                  .to_date
    @end_date = @start_date.to_date + 6.days
  end

  def show; end

  def edit; end

  def update
    if @user.update_with_password user_params
      bypass_sign_in @user
      redirect_to users_path, notice: 'Password successfully changed!'
    else
      redirect_to users_path, alert: 'Password updating failed!'
    end
  end

  def allocate_roles; end

  def update_roles
    if @user.update role_params
      Role::ROLES.each do |r|
        role_adder(@user, r)
      end

      redirect_to users_path, notice: 'Roles successfully updated!'
    else
      redirect_to users_path, alert: 'Updating roles failed!'
    end
  end

  def destroy
    redirect_to users_path if @user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation,
                                 :current_password)
  end

  def role_params
    params.require(:user).permit(:cell, :mc)
  end

  def role_adder(user, role)
    if params[role] == '1'
      user.add_role(role)
    elsif params[role] == '0'
      user.remove_role(role)
    end
  end
end
