# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET #new' do
    context 'unauthenticated' do
      it do
        get(:new)
        should redirect_to new_user_session_path
      end
    end
    context 'normal user' do
      it do
        sign_in create(:user)
        get :new
        should redirect_to users_path
      end
    end
    context 'mc' do
      it do
        sign_in create(:user, mc: true)
        get :new
        should respond_with :ok
      end
    end
  end

  describe 'POST #create' do
    before do
      @params = {
        user: {
          username: 'Asd', matric_num: 'A101010J', contact_num: '85851212',
          email: 'asd@example.com', cell: 'marketing', mc: false,
          password: '123456', password_confirmation: '123456'
        }
      }
    end

    context 'unauthenticated' do
      it do
        expect { post :create, params: @params }
          .to_not change { User.count }
        should redirect_to new_user_session_path
      end
    end
    context 'normal user' do
      it do
        sign_in create(:user)
        expect { post :create, params: @params }
          .to_not change { User.count }
        should redirect_to users_path
      end
    end
    context 'mc' do
      it do
        sign_in create(:user, mc: true)
        expect { post :create, params: @params }
          .to change { User.count }.by(1)
        should redirect_to users_path
      end
    end
  end

  describe 'after_sign_up_path_for' do
    it { expect(subject.after_sign_up_path_for(nil)).to eq(users_path) }
  end

  describe 'after_inactive_sign_up_path_for' do
    it {
      expect(subject.after_inactive_sign_up_path_for(nil)).to eq(users_path)
    }
  end
end
