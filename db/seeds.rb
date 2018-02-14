# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' },
#                          { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Place.create(name: 'YIH')
Place.create(name: 'AS8')

('08:00'.to_time.to_i..'09:30'.to_time.to_i).step(30.minutes).each do |time|
  start = Time.zone.at(time)
  puts start
  TimeRange.create(start_time: start, end_time: start + 30.minutes)
end
puts "Second Part: "
('10:00'.to_time.to_i..'20:00'.to_time.to_i).step(1.hour.to_i).each do |time|
  start = Time.zone.at(time)
  puts start
  TimeRange.create(start_time: start, end_time: start + 1.hour)
end

User.create(email: 'test@example.com', password: '123456')

# Timeslots in YIH
Date::DAYNAMES.each do |day|
  puts day
  TimeRange.all.each do |tr|
    mc = nil
    open = tr.start_time.in_time_zone.strftime('%H%M')
    close = tr.end_time.in_time_zone.strftime('%H%M')
    puts open
    puts close 
    if day == 'Sunday'
      next if open < '0130' || close > '0700'
      mc = (open == '0130' || close == '0700')
      puts mc
    elsif day == 'Saturday'
      next if open < '0030' || close > '0900'
      mc = (open == '0030' || close == '0900')
      puts mc
    else
      next if open < '0030' || close > '1300'
      mc = (open == '0030' || close == '1300')
      puts mc
    end

    Timeslot.create(mc_only: mc, day: day, default_user: User.take,
                    time_range: tr, place: Place.find_by(name: 'YIH'))
  end
end

# Timeslots in AS8
Date::DAYNAMES.each do |day|
  TimeRange.all.each do |tr|
    mc = false
    open = tr.start_time.in_time_zone.strftime('%H%M')
    close = tr.end_time.in_time_zone.strftime('%H%M')

    next if day == 'Sunday'
    next if (day == 'Saturday') && (open < '0800' || close > '0900')
    next if open < '0000' || close > '1200'

    Timeslot.create(mc_only: mc, day: day, default_user: User.take,
                    time_range: tr, place: Place.find_by(name: 'AS8'))
  end
end
