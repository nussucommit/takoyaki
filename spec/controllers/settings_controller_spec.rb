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
        get :edit
        should redirect_to(root_path)
      end
    end
    context 'mc' do
      it do
        sign_in create(:user, mc: true)
        get :edit
        should redirect_to(root_path)
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
        put :update, params: { setting: { mc_only: true } }
        should redirect_to(root_path)
      end
    end
    context 'mc' do
      it do
        sign_in create(:user, mc: true)
        put :update, params: { setting: { mc_only: true } }
        should redirect_to(root_path)
      end
    end
    context 'admin' do
      before do
        user = create(:user, mc: true)
        user.add_role(:admin)
        sign_in user
      end

      it do
        Setting.retrieve.update(mc_only: false)
        expect do
          put :update, params: { setting: { mc_only: true } }
        end.to change { Setting.retrieve.mc_only }.from(false).to(true)
      end

      it 'handles failure' do
        setting = Setting.retrieve
        setting.update(mc_only: false)
        allow(setting).to receive(:update).and_return(false)
        allow(Setting).to receive(:retrieve).and_return(setting)
        put :update, params: { setting: { mc_only: true } }
        should redirect_to edit_settings_path
        expect(flash['alert']).to eq('Updating settings failed!')
      end
    end
  end
end
