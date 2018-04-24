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
  end

  describe 'PUT #update' do
    it 'redirects when unauthenticated' do
      put :update, params: { id: create(:user).id }
      should redirect_to(new_user_session_path)
    end
    it 'updates password' do
      user = create(:user, password: '123456')
      sign_in user
      expect do
        put :update, params: { id: user.id, user: { password: '1234567',
                                                    confirmation_password:
                                                    '1234567',
                                                    current_password:
                                                    '123456' } }
      end.to change {
        User.find(user.id).valid_password?('1234567')
      }.from(false).to(true)
      should redirect_to(users_path)
    end
    it 'password not updated if current password wrong' do
      user = create(:user, password: '123456')
      sign_in user
      expect do
        put :update, params: { id: user.id, user: { password: '1234567',
                                                    confirmation_password:
                                                    '1234567',
                                                    current_password:
                                                    '12345678' } }
      end.to_not change {
        User.find(user.id).valid_password?('123456')
      }.from(true)
      should redirect_to(users_path)
    end
  end

  describe 'PUT #update_role' do
    it 'redirects when unauthenticated' do
      put :update_role, params: { id: create(:user).id }
      should redirect_to(new_user_session_path)
    end
    it 'denies access to normal user' do
      user = create(:user)
      sign_in user
      expect do
        put :update_role, params: { id: user.id }
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
          put :update_role, params: { id: user.id, user: { cell: 'technical',
                                                           mc: 'false' },
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
          put :update_role, params: { id: user.id, user: { cell: 'technical',
                                                           mc: 'false' },
                                      admin: 0 }
        end.to change {
          User.find(user.id).has_role?(:admin)
        }.from(true).to(false)
        should redirect_to(users_path)
      end
      it 'change cell' do
        user = create(:user, cell: 'marketing')
        user.add_role(:admin)
        expect do
          put :update_role, params: { id: user.id, user: { cell: 'technical',
                                                           mc: 'false' },
                                      admin: 0 }
        end.to change {
          User.find(user.id).cell
        }.from('marketing').to('technical')
        should redirect_to(users_path)
      end
      it 'change mc' do
        user = create(:user, mc: false)
        user.add_role(:admin)
        expect do
          put :update_role, params: { id: user.id, user: { cell: 'technical',
                                                           mc: 'true' },
                                      admin: 0 }
        end.to change {
          User.find(user.id).mc
        }.from(false).to(true)
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
