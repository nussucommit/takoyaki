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
  end
end
