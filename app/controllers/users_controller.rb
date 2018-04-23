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
    if @user.update user_params
      sign_in :user, @user, bypass: true
      redirect_to users_path, notice: 'Password Successfully Updated'
    else
      redirect_to users_path, alert: 'Fail to Update Password'
    end
  end

  def allocate_role
    @user = User.find params[:id]
  end

  def update_role
    @user = User.find params[:id]
    if @user.update role_params
      redirect_to users_path, notice: 'Role Updated Succesfully'
    else
      redirect_to users_path, alert: 'Fail to Update Role'
    end
  end

  def destroy
    @user = User.find params[:id]

    redirect_to users_path if @user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def role_params
    params.permit(:cell, :mc)
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
