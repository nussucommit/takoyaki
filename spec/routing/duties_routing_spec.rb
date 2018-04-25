# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DutiesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/duties').to route_to('duties#index')
    end

    it 'routes to #generate_duties' do
      expect(post: '/duties/generate').to route_to('duties#generate_duties')
    end

    it 'routes to /places#index' do
      expect(get: '/duties/places').to route_to('duties/places#index')
    end

    it 'routes to /places#edit' do
      expect(get: '/duties/places/1/edit')
        .to route_to(controller: 'duties/places', action: 'edit', id: '1')
    end

    it 'routes to /places#update' do
      expect(put: '/duties/places/1')
        .to route_to(controller: 'duties/places', action: 'update',
                     id: '1')
    end
  end
end
