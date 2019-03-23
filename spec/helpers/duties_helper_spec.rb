# frozen_string_literal: true

require 'rails_helper'

# Each test creates 24 timeslots to make sure time_range factory
# always starts from the same time.

RSpec.describe DutiesHelper, type: :helper do
  describe '#process_duties' do
    it 'merges duties from same user' do
      user = create(:user)
      place = create(:place)
      timeslots = create_list(:timeslot, 24, place: place)
      duties = []
      (0..9).each do |i|
        duties.push(create(:duty, user: user, timeslot: timeslots[i]))
      end
      pd = helper.process_duties(duties[0].date, duties[-1].date,
                                 duties[0].time_range.start_time,
                                 duties[-1].time_range.start_time,
                                 [place])
      expect(pd.length).to eq(1)
      expect(pd[0].length).to eq(1)
      expect(pd[0][0].length).to eq(1)
    end

    it 'should add prefix and suffix to pad duties' do
      user = create(:user)
      place = create(:place)
      timeslots = create_list(:timeslot, 24, place: place)
      duties = []
      (0..9).each do |i|
        duties.push(create(:duty, user: user, timeslot: timeslots[i]))
      end
      pd = helper.process_duties(duties[0].date, duties[-1].date,
                                 duties[0].time_range.start_time - 1.hour,
                                 duties[-1].time_range.start_time + 1.hour,
                                 [place])
      expect(pd.length).to eq(1)
      expect(pd[0].length).to eq(1)
      expect(pd[0][0].length).to eq(3)
    end

    it 'should not merge duties from different users' do
      user1 = create(:user)
      user2 = create(:user)
      place = create(:place)
      timeslots = create_list(:timeslot, 24, place: place)
      duties = []
      (0..4).each do |i|
        duties.push(create(:duty, user: user1, timeslot: timeslots[i]))
      end
      (5..9).each do |i|
        duties.push(create(:duty, user: user2, timeslot: timeslots[i]))
      end
      pd = helper.process_duties(duties[0].date, duties[-1].date,
                                 duties[0].time_range.start_time,
                                 duties[-1].time_range.start_time,
                                 [place])
      expect(pd.length).to eq(1)
      expect(pd[0].length).to eq(1)
      expect(pd[0][0].length).to eq(2)
    end

    it 'should not merge duties from same user but different place' do
      user = create(:user)
      place1 = create(:place)
      place2 = create(:place)
      timeslots = create_list(:timeslot, 5, place: place1) +
                  create_list(:timeslot, 19, place: place2)
      duties = []
      (0..9).each do |i|
        duties.push(create(:duty, user: user, timeslot: timeslots[i]))
      end
      pd = helper.process_duties(duties[0].date, duties[-1].date,
                                 duties[0].time_range.start_time,
                                 duties[-1].time_range.start_time,
                                 [place1, place2])
      expect(pd.length).to eq(1)
      expect(pd[0].length).to eq(2)
      expect(pd[0][0].length).to eq(2)
      expect(pd[0][0][1][:user]).to eq(nil) # suffix padding
      expect(pd[0][1].length).to eq(2)
      expect(pd[0][1][0][:user]).to eq(nil) # prefix padding
    end

    it 'should not merge duties from same user but different status' do
      user = create(:user)
      place = create(:place)
      timeslots = create_list(:timeslot, 24, place: place)
      duties = []
      (0..4).each do |i|
        duties.push(create(:duty, user: user, timeslot: timeslots[i],
                                  free: true))
      end
      (5..9).each do |i|
        duties.push(create(:duty, user: user, timeslot: timeslots[i]))
      end
      pd = helper.process_duties(duties[0].date, duties[-1].date,
                                 duties[0].time_range.start_time,
                                 duties[-1].time_range.start_time,
                                 [place])
      expect(pd.length).to eq(1)
      expect(pd[0].length).to eq(1)
      expect(pd[0][0].length).to eq(2)
    end

    it 'should not merge duties from same user but different user to drop' do
      user1 = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      place = create(:place)
      timeslots = create_list(:timeslot, 24, place: place)
      duties = []
      (0..4).each do |i|
        duties.push(create(:duty, user: user1, timeslot: timeslots[i],
                                  request_user: user2))
      end
      (5..9).each do |i|
        duties.push(create(:duty, user: user1, timeslot: timeslots[i],
                                  request_user: user3))
      end
      pd = helper.process_duties(duties[0].date, duties[-1].date,
                                 duties[0].time_range.start_time,
                                 duties[-1].time_range.start_time,
                                 [place])
      expect(pd.length).to eq(1)
      expect(pd[0].length).to eq(1)
      expect(pd[0][0].length).to eq(2)
    end
  end

  describe '#current_user_hours' do
    it 'calculates hours correctly' do
      user = create(:user)
      sign_in user
      duties = create_list(:duty, 10, user: user)
      assign(:start_date, duties[0].date)
      assign(:end_date, duties[9].date)

      result = helper.current_user_hours
      expect(result).to eq((duties[-1].time_range.end_time -
       duties[0].time_range.start_time) / 3600)

      # Hack to reset time_range
      create_list(:duty, 14, user: user)
    end
  end
end
