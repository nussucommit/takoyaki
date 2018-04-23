# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show; end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if can?(:manage, User)
      Role::ROLES.each do |r|
        role_adder(@user, r)
      end
    end
    @user.update(user_params)
    # Sign in the user by passing validation in case their password changed
    # bypass_sign_in(@user)
    redirect_to users_path
  end

  def destroy
    user = User.find params[:id]
    user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def role_adder(user, role)
    if params[role] == '1'
      user.add_role(role)
    elsif params[role] == '0'
      user.remove_role(role)
    end
  end
end
