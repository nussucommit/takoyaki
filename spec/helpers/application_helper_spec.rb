# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#calc_colspan' do
    it 'calculates colspan correctly' do
      expect(calc_colspan(Time.strptime('0900', '%H%M'),
                          Time.strptime('1100', '%H%M')))
        .to eq(4)
    end
  end
  describe '#flash_class' do
    it do
      expect(flash_class(:notice))
        .to eq('alert alert-success alert-dismissible')
    end
    it do
      expect(flash_class(:alert)).to eq('alert alert-danger alert-dismissible')
    end
  end
end
