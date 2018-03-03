# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnouncementsController, type: :controller do
	describe 'GET #index' do 
		it 'does it successfully' do
			get :index
		  should respond_with :ok
		end

    it "populates an array of contacts" do
      announcement = FactoryBot.create(:announcement)
      get :index
      assigns(:announcements).should eq([announcement])
    end

    it 'renders index template' do
      get :index
      expect(response).to render_template("announcements/index")
    end
	end

  describe 'POST #create' do
    it 'creates a new announcement' do
      expect do
        post :create, params: { announcement: attributes_for(:announcement) }
      end.to change(Announcement, :count).by(1)
    end

    it 'redirects to announcement_path' do
      post :create, params: { announcement: attributes_for(:announcement) }
      should redirect_to announcements_path
    end
  end

  describe 'PUT #update' do
    it 'updates an announcement' do
      announcement = FactoryBot.create(:announcement)
      put :update, params: { id: announcement.id, announcement: { :subject => "new subject", :details => "new details" } }
    end

    it 'redirects to announcement_path' do
      announcement = FactoryBot.create(:announcement)
      put :update, params: { id: announcement.id, announcement: { :subject => "new subject", :details => "new details" } }
      should redirect_to announcements_path
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a new announcement' do
      announcement = FactoryBot.create(:announcement)
      expect do
        delete :destroy, params: { id: announcement.id }
      end.to change(Announcement, :count).by(-1)
    end

    it 'redirects to announcement_path' do
      announcement = FactoryBot.create(:announcement)
      delete :destroy, params: { id: announcement.id }
      should redirect_to announcements_path
    end
  end
end
