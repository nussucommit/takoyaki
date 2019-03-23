# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnouncementsController, type: :controller do
  describe 'GET #index' do
    context 'normal user' do
      it do
        sign_in create(:user)
        get :index
        should respond_with :ok
        assert_template :index
      end
    end

    context 'admin' do
      it do
        user = create(:user, mc: true)
        sign_in user
        get :index
        should respond_with :ok
        assert_template :index
      end
    end
  end

  describe 'POST #create' do
    it 'denies access to normal user' do
      sign_in create(:user)
      expect do
        post :create, params: { announcement: attributes_for(:announcement) }
      end.to_not change(Announcement, :count)
      should redirect_to duties_path
    end

    context 'valid attributes' do
      before do
        user = create(:user, mc: true)
        sign_in user
      end

      it 'creates a new announcement' do
        expect do
          post :create, params: { announcement: attributes_for(:announcement) }
        end.to change(Announcement, :count).by(1)
      end

      it 'redirects to announcement_path' do
        post :create, params: { announcement: attributes_for(:announcement) }
        should redirect_to duties_path
      end
    end

    context 'invalid attributes' do
      before do
        user = create(:user, mc: true)
        sign_in user
      end

      it 'does not create new announcement with invalid subject' do
        expect do
          post :create, params: { announcement: attributes_for(
            :announcement, subject: ''
          ) }
        end.to change(Announcement, :count).by(0)
      end

      it 'does not create new announcement with invalid details' do
        expect do
          post :create, params: { announcement: attributes_for(
            :announcement, details: ''
          ) }
        end.to change(Announcement, :count).by(0)
      end
    end
  end

  describe 'PUT #update' do
    it 'denies access to normal user' do
      sign_in create(:user)
      announcement = create(:announcement)
      put :update, params: { id: announcement.id, announcement:
          attributes_for(:announcement, subject: 'new subject', details: 'new
            details') }
      expect(Announcement.find(announcement.id).subject)
        .not_to eq('new subject')
      should redirect_to duties_path
    end

    context 'valid attributes' do
      before do
        user = create(:user, mc: true)
        sign_in user
      end

      it 'updates an announcement' do
        announcement = create(:announcement)
        put :update, params: { id: announcement.id, announcement:
          attributes_for(:announcement, subject: 'new subject', details: 'new
            details') }
      end

      it 'redirects to announcement_path' do
        announcement = create(:announcement)
        put :update, params: { id: announcement.id, announcement:
          attributes_for(:announcement, subject: 'new subject', details: 'new
            details') }
        should redirect_to duties_path
      end
    end

    context 'invalid attributes' do
      it 'does not update new announcement with invalid subject' do
        user = create(:user, mc: true)
        sign_in user
        announcement = create(:announcement)
        put :update, params: { id: announcement.id,
                               announcement: { subject: '', details: 'new
                                details' } }
        expect(announcement.subject).to eq('MyText')
        expect(announcement.details).to eq('MyText')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'denies access to normal user' do
      sign_in create(:user)
      announcement = create(:announcement)
      expect do
        delete :destroy, params: { id: announcement.id }
      end.to_not change(Announcement, :count)
      should redirect_to duties_path
    end

    context 'Authenticated' do
      before do
        user = create(:user, mc: true)
        sign_in user
      end

      it 'deletes a new announcement' do
        announcement = create(:announcement)
        expect do
          delete :destroy, params: { id: announcement.id }
        end.to change(Announcement, :count).by(-1)
      end

      it 'redirects to announcement_path' do
        announcement = create(:announcement)
        delete :destroy, params: { id: announcement.id }
        should redirect_to duties_path
      end
    end
  end
end
