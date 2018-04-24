# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.order(cell: :asc)
  end

  def show; end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    if current_user.id.equal? params[:id].to_i
      update_password(@user)
    else
      redirect_to users_path, alert: 'Not Authorised'
    end
  end

  def allocate_role
    @user = User.find params[:id] if can?(:manage, User)
  end

  def update_role
    @user = User.find params[:id]

    if can?(:manage, User)
      add_roles(@user)
    else
      redirect_to users_path, alert: 'Not Authorised'
    end
  end

  def destroy
    user = User.find params[:id]

    redirect_to users_path if user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation,
                                 :current_password)
  end

  def update_password(user)
    if user.update_with_password user_params
      bypass_sign_in user
      redirect_to users_path, notice: 'Password Successfully Updated'
    else
      redirect_to users_path, alert: 'Fail to Update Password'
    end
  end

  def add_roles(user)
    if user.update role_params
      Role::ROLES.each do |r|
        role_adder(user, r)
      end

      redirect_to users_path, notice: 'Role Updated Succesfully'
    else
      redirect_to users_path, alert: 'Fail to Update Role'
    end
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
