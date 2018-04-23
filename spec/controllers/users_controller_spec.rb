# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    it 'redirects when unauthenticated' do
      get :index
      should redirect_to new_user_session_path
    end
    it 'renders when authenticated' do
      sign_in create(:user)
      get :index
      should respond_with :ok
    end
  end
  describe 'GET #edit' do
    it 'redirects when unauthenticated' do
      get :edit, params: { id: create(:user).id }
      should redirect_to(new_user_session_path)
    end
    it 'denies access to normal user' do
      user = create(:user)
      sign_in user
      expect do
        get :edit, params: { id: user.id }
      end.to raise_error(CanCan::AccessDenied)
    end
    it 'renders for admin' do
      user = create(:user)
      user.add_role(:admin)
      sign_in user
      get :edit, params: { id: user.id }
      should respond_with :ok
    end
  end
  describe 'PUT #update' do
    it 'redirects when unauthenticated' do
      put :update, params: { id: create(:user).id }
      should redirect_to(new_user_session_path)
    end
    it 'denies access to normal user' do
      user = create(:user)
      sign_in user
      expect do
        put :update, params: { id: user.id }
      end.to raise_error(CanCan::AccessDenied)
    end
    context 'admin' do
      before do
        user = create(:user)
        user.add_role(:admin)
        sign_in user
      end
      it 'add role' do
        user = create(:user)
        expect do
          put :update, params: { id: user.id, user: { password: '' },
                                 Role::ROLES.last => 1 }
        end.to change {
          User.find(user.id).has_role?(Role::ROLES.last)
        }.from(false).to(true)
        should redirect_to(users_path)
      end
      it 'remove role' do
        user = create(:user)
        user.add_role(:admin)
        expect do
          put :update, params: { id: user.id, user: { password: '' }, admin: 0 }
        end.to change {
          User.find(user.id).has_role?(:admin)
        }.from(true).to(false)
        should redirect_to(users_path)
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'redirects when unauthenticated' do
      delete :destroy, params: { id: create(:user).id }
      should redirect_to new_user_session_path
    end
    it 'works when authenticated' do
      user = create(:user)
      user.add_role(:admin)
      sign_in user
      user = create(:user)
      expect do
        delete :destroy, params: { id: user.id }
      end.to change { User.count }.by(-1)
      should redirect_to users_path
    end
  end
end
