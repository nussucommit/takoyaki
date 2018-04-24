# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvailabilitiesHelper, type: :helper do
  describe '#stylise_user' do
    it 'bolds mcs' do
      expect(helper.stylise_user(username: 'anu', mc: true))
        .to eq('<span class="mc">anu</span>')
    end
    it 'returns username unstyled for non-mc' do
      expect(helper.stylise_user(username: 'anu', mc: false))
        .to eq('anu')
    end
  end

  describe '#calc_offset' do
    it 'calculates correctly' do
      expect(
        helper.calc_offset(
          Struct.new(:start_time).new(Time.strptime('0800', '%H%M'))
        )
      )
        .to eq(640)
    end
  end

  describe '#calc_slot_height' do
    it 'calculates correctly for half an hour' do
      expect(
        helper.calc_slot_height(
          Struct.new(:start_time, :end_time)
          .new(Time.strptime('0800', '%H%M'), Time.strptime('0830', '%H%M'))
        )
      )
        .to eq(38.0)
    end
    it 'calculates correctly for one hour' do
      expect(
        helper.calc_slot_height(
          Struct.new(:start_time, :end_time)
          .new(Time.strptime('0800', '%H%M'), Time.strptime('0900', '%H%M'))
        )
      )
        .to eq(78.0)
    end
  end
end
