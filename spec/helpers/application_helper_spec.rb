# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#calc_colspan' do
    it 'calculates colspan correctly' do
      expect(calc_colspan(Time.strptime('0900','%H%M'),
                          Time.strptime('1100', '%H%M')))
        .to eq(4)
    end
  end
end
