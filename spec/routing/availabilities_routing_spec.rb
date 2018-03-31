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

  it 'routes to #default_index' do
    expect(get: '/availabilities/default')
      .to route_to('availabilities#default_index')
  end

  it 'routes to #default_edit' do
    expect(get: '/availabilities/default/places/1')
      .to route_to(controller: 'availabilities', action: 'default_edit',
                   id: '1')
  end

  it 'routes to #default_update' do
    expect(post: '/availabilities/default/places/1')
      .to route_to(controller: 'availabilities', action: 'default_update',
                   id: '1')
  end

  it 'routes to #all' do
    expect(get: '/availabilities/all').to route_to('availabilities#all')
  end
end
