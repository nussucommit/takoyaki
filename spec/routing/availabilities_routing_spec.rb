# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvailabilitiesController, type: :routing do
  it 'routes to #index' do
    expect(get: '/availabilities').to route_to('availabilities#index')
  end

  it 'routes to #update_availabilities' do
    expect(post: '/availabilities').to route_to(
      'availabilities#update_availabilities'
    )
  end

  it 'routes to /places#index' do
    expect(get: '/availabilities/places')
      .to route_to('availabilities/places#index')
  end

  it 'routes to /places#edit' do
    expect(get: '/availabilities/places/1/edit')
      .to route_to(controller: 'availabilities/places', action: 'edit', id: '1')
  end

  it 'routes to /places#update' do
    expect(put: '/availabilities/places/1')
      .to route_to(controller: 'availabilities/places', action: 'update',
                   id: '1')
  end

  it 'routes to #all' do
    expect(get: '/availabilities/show_everyone')
      .to route_to('availabilities#show_everyone')
  end
end
