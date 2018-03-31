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

  it 'routes to #default' do
    expect(get: '/availabilities/default').to route_to('availabilities#default')
  end

  it 'routes to #set_default' do
    expect(get: '/availabilities/all').to route_to('availabilities#all')
  end
end
