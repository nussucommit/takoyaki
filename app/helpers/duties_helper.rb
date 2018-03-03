# frozen_string_literal: true

module DutiesHelper
  def process_duties(start_date, end_date)
    start_date.upto(end_date).map do |day|
      Place.all.map do |place|
        process_day_place(day, place)
      end
    end
  end

  private

  def process_day_place(day, place)
    first = TimeRange.all.first
    last = TimeRange.all.last
    result = []
    duties = Duty.where(date: day)
                 .joins(:timeslot).where('timeslots.place' => place)
                 .ordered_by_start_time.includes(:timeslot, :user)
    return [{ name: nil, colspan: ((last.end_time - first.start_time) / 0.5.hours).round }] if duties.empty?
    first_duty = duties.first.timeslot.time_range
    if first.start_time < first_duty.start_time
      result.push(name: nil, colspan: ((first_duty.start_time - first.start_time) / 0.5.hours).round)
    end
    duties = duties.to_a
    colspan = 1
    duties.each_with_index do |duty, index|
      if duties[index]&.user&.email == duties[index + 1]&.user&.email
        duration = ((duty.timeslot.time_range.end_time - duty.timeslot.time_range.start_time) / 0.5.hours).round
        colspan += duration
      else
        result.push(name: duty.user.email, colspan: colspan)
        colspan = 1
      end
    end
    last_duty = duties.last.timeslot.time_range
    if last.start_time > last_duty.start_time
      result.push(name: nil, colspan: ((last.start_time - last_duty.start_time) / 0.5.hours).round)
    end
    result
  end
end
