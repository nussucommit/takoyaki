# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to('users#index')
    end

    it 'routes to #allocate_roles' do
      expect(get: '/users/1/allocate_roles')
        .to route_to('users#allocate_roles', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/edit').to route_to('users#edit', id: '1')
    end

    it 'routes to #show' do
      expect(get: '/users/1').to route_to('users#show', id: '1')
    end

    it 'routes to #update' do
      expect(put: '/users/1').to route_to('users#update', id: '1')
    end

    it 'routes to #update' do
      expect(patch: '/users/1').to route_to('users#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1').to route_to('users#destroy', id: '1')
    end
  end
end
