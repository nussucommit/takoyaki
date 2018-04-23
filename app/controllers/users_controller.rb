# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, except: %i[index show edit]

  def index
    # check_admin
    @users = User.order(cell: :asc)
  end

  def show; end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if current_user.has_role?(:admin)
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
    @user = User.find params[:id]
    @user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def check_admin
    redirect_to root_path unless current_user.has_role?(:admin)
  end

  def role_adder(user, role)
    if params[role] == '1'
      user.add_role(role)
    elsif params[role] == '0'
      user.remove_role(role)
    end
  end
end
