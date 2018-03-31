# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProblemReportsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/problem_reports').to route_to('problem_reports#index')
    end

    it 'routes to #new' do
      expect(get: '/problem_reports/new').to route_to('problem_reports#new')
    end

    it 'routes to #create' do
      expect(post: '/problem_reports').to route_to('problem_reports#create')
    end

    it 'routes to #update' do
      expect(patch: '/problem_reports/1').to route_to('problem_reports#update',
                                                      id: '1')
    end
  end
end
