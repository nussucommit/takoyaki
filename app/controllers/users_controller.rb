# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  def check_admin
    if !current_user.has_role?(:admin)
       redirect_to root_path
    end
  end
  def role_adder(role)
    if params[role] == '1'
      @user.add_role(role)
    elsif params[role] == '0'
      @user.remove_role(role)
    end
    end

  def index
    @users = User.all
  end

  def edit
    @user = User.find params[:id]
  
  end

  def update
    @user = User.find params[:id]
    Role::ROLES.each do |r|
      role_adder(r)
    end
    redirect_to users_path
    #else
    #  redirect_to edit_user_path
    
  end
  
  def show
    @user = User.find params[:id]
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to users_path
  end

  private def user_params
    params.require(:user)
  end

  
end
