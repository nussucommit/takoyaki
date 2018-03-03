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
    result = []
    duties = Duty.where(date: day)
                 .joins(:timeslot).where('timeslots.place' => place)
                 .ordered_by_start_time.includes(:timeslot, :user, :time_range)
    if duties.empty?
      return [{ name: nil, colspan: calc_colspan(TimeRange.first.start_time, TimeRange.last.end_time) }]
    end

    starting_time = TimeRange.order(:start_time).first.start_time
    starting_duty = duties.first.timeslot.time_range.start_time
    if starting_time < starting_duty
      result.push(name: nil, colspan: calc_colspan(starting_time, starting_duty))
    end

    result += process_duty(duties)

    ending_time = TimeRange.last.start_time
    ending_duty = duties.last.timeslot.time_range.start_time
    if ending_time > ending_duty
      result.push(name: nil, colspan: calc_colspan(ending_duty, ending_time))
    end

    result
  end

  def process_duty(duties)
    colspan = 0
    result = []
    duties.each_with_index do |duty, index|
      colspan += calc_colspan(duty.timeslot.time_range.start_time, duty.timeslot.time_range.end_time)
      unless duties[index]&.user&.email == duties[index + 1]&.user&.email
        result.push(name: duty.user.email, colspan: colspan)
        colspan = 0
      end
    end
    result
  end

  def calc_colspan(start_time, end_time)
    ((end_time - start_time) / 0.5.hours).round
  end
end
