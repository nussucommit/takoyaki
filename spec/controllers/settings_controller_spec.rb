# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  describe 'GET #edit' do
    context 'unauthenticated' do
      it do
        get :edit
        should redirect_to(new_user_session_path)
      end
    end
    context 'normal user' do
      it do
        sign_in create(:user)
        expect { get :edit }.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'mc' do
      it do
        sign_in create(:user, mc: true)
        expect { get :edit }.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'admin' do
      it do
        user = create(:user, mc: true)
        user.add_role(:admin)
        sign_in user
        get :edit
        should respond_with(:ok)
      end
    end
  end

  describe 'PUT #update' do
    context 'unauthenticated' do
      it do
        put :update, params: { setting: { mc_only: true } }
        should redirect_to(new_user_session_path)
      end
    end
    context 'normal user' do
      it do
        sign_in create(:user)
        expect do
          put :update, params: { setting: { mc_only: true } }
        end.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'mc' do
      it do
        sign_in create(:user, mc: true)
        expect do
          put :update, params: { setting: { mc_only: true } }
        end.to raise_error(CanCan::AccessDenied)
      end
    end
    context 'admin' do
      it do
        user = create(:user, mc: true)
        user.add_role(:admin)
        sign_in user
        Setting.retrieve.update(mc_only: false)
        expect do
          put :update, params: { setting: { mc_only: true } }
        end.to change { Setting.retrieve.mc_only }.from(false).to(true)
      end
    end
  end
end