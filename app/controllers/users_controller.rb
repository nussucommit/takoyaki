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
