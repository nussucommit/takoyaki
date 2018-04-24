# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to('users#index')
    end

    it 'routes to #allocate_role' do
      expect(get: '/users//1/allocate_role')
      	.to route_to('users#allocate_role', id: '1')
    end
  end
end