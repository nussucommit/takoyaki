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

  describe '#choose_form_path' do
    context 'availabilities/places' do
      it do
        controller.params[:controller] = 'availabilities/places'
        controller.params[:id] = 1
        expect(helper.choose_form_path).to eq('/availabilities/places/1')
      end
    end
    context 'availabilities' do
      it do
        controller.params[:controller] = 'availabilities'
        expect(helper.choose_form_path).to eq('/availabilities')
      end
    end
  end

  describe '#generate' do
    it do
      availability = Struct.new(:id, :status).new(2, true)
      expect(helper.generate(availability))
        .to eq('<input type="checkbox" name="availability_ids[2]" ' \
               'id="availability_ids_2" value="2" style="visibility: hidden;"' \
               ' checked="checked" />')
    end

    it do
      availability = Struct.new(:id, :status).new(42, false)
      expect(helper.generate(availability))
        .to eq('<input type="checkbox" name="availability_ids[42]" ' \
               'id="availability_ids_42" value="42" ' \
               'style="visibility: hidden;" />')
    end
  end

  describe '#generate_cell' do
    it do
      assign(:availabilities,
             [1, 10] => Struct.new(:id, :status).new(2, true))
      expect(helper.generate_cell(1, Struct.new(:id).new(10)))
        .to eq('<input type="checkbox" name="availability_ids[2]" ' \
               'id="availability_ids_2" value="2" style="visibility: hidden;"' \
               ' checked="checked" />')
    end

    it do
      assign(:availabilities,
             [10, 100] => Struct.new(:id, :status).new(42, false))
      expect(helper.generate_cell(10, Struct.new(:id).new(100)))
        .to eq('<input type="checkbox" name="availability_ids[42]" ' \
               'id="availability_ids_42" value="42" ' \
               'style="visibility: hidden;" />')
    end
  end
end
