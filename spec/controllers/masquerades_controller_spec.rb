# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MasqueradesController, type: :controller do
  describe 'GET masquerades#show' do
    context 'normal user' do
      it 'should deny request from normal user' do
        sign_in create(:user)
        get :show, params: { id: create(:user) }
        should redirect_to root_path
        expect(flash['alert']).to eq('You are not authorized to ' \
                                     'access this page.')
      end
    end

    context 'admin' do
      before do
        admin = create(:user)
        admin.add_role :admin
        sign_in admin
      end

      it 'should allow request from admin user' do
        get :show, params: { id: create(:user) }
        should redirect_to users_path
        expect(user_masquerade?).to be(true)
      end

      it 'should not allow masquerade after masquerading as normal user' do
        get :show, params: { id: create(:user) }
        get :show, params: { id: create(:user) }
        should redirect_to root_path
        expect(flash['alert']).to eq('You are not authorized to ' \
                                     'access this page.')
      end
    end
  end

  describe 'GET masquerades#back' do
    context 'normal user' do
      it 'should not allow normal user to get back from masquerading' do
        sign_in create(:user)
        get :back
        should redirect_to root_path
        expect(flash['alert']).to eq('You are not authorized to ' \
                                     'access this page.')
      end
    end

    context 'admin' do
      before do
        admin = create(:user)
        admin.add_role :admin
        sign_in admin
      end

      it 'should allow admin to get back without even masquerading' do
        get :back
        should redirect_to users_path
        expect(user_masquerade?).to be(false)
      end

      it 'should allow admin to get back from masquerading' do
        get :show, params: { id: create(:user) }
        expect { get :back }.to change(user_masquerade?).from(true).to(false)
        should redirect_to users_path
      end

      it 'should allow admin to get back from multiple masquerading' do
        5.times do
          temp_admin = create(:user)
          temp_admin.add_role(:admin)
          get :show, params: { id: temp_admin }
        end

        expect { get :back }.to change(user_masquerade?).from(true).to(false)
        should redirect_to users_path
      end
    end
  end
end
