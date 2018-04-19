# frozen_string_literal: true

module DutiesHelper
  def process_duties(start_date, end_date)
    all_duties = Duty.includes(:user, timeslot: [:time_range])
                     .order('time_ranges.start_time')

    start_date.upto(end_date).map do |day|
      Place.all.map do |place|
        process_day_place(all_duties.where(date: day,
                                           'timeslots.place' => place))
      end
    end
  end

  private

  # TODO: To be refactored later on
  # rubocop:disable Metrics/LineLength, Metrics/AbcSize, Metrics/MethodLength
  def process_day_place(duties)
    result = []
    if duties.empty?
      return [{ name: nil,
                colspan: calc_colspan(TimeRange.first.start_time,
                                      TimeRange.last.end_time) }]
    end

    starting_time = TimeRange.order(:start_time).first.start_time
    starting_duty = duties.first.timeslot.time_range.start_time
    if starting_time < starting_duty
      result.push(name: nil, colspan: calc_colspan(starting_time, starting_duty))
    end

    result += process_duty(duties)

    ending_time = TimeRange.order(:start_time).last.start_time
    ending_duty = duties.last.timeslot.time_range.start_time
    if ending_time > ending_duty
      result.push(name: nil, colspan: calc_colspan(ending_duty, ending_time))
    end

    result
  end

  def process_duty(duties)
    index_array = []
    span_free = duties[0].free
    span_user_id = duties[0]&.user.id
    span_request_user_id = duties[0]&.request_user_id
    index_array.push(0)
    index = 1
    while index < duties.length do
      current_duty = duties[index]
      if span_free != current_duty.free
        index_array.push(index)
        span_free = current_duty.free
        span_user_id = current_duty&.user.id
        span_request_user_id = current_duty&.request_user_id
      else
        if !span_free && !current_duty.free
          if !span_request_user_id.nil? && span_request_user_id != current_duty&.request_user_id
            index_array.push(index)
            span_free = current_duty.free
            span_user_id = current_duty&.user.id
            span_request_user_id = current_duty&.request_user_id
          else
            if span_user_id != current_duty&.user.id
              index_array.push(index)
              span_free = current_duty.free
              span_user_id = current_duty&.user.id
              span_request_user_id = current_duty&.request_user_id
            end
          end
        end
      end
      index += 1
    end
    index_array.push(duties.length)
    result = []
    start_index = index_array[0]
    end_index = index_array[1]
    next_index = 2
    while next_index <= index_array.length do
      span_duty = []
      colspan = 0
      username = duties[start_index]&.user.username
      free = duties[start_index].free
      request_user_id = duties[start_index]&.request_user_id
      while start_index < end_index do
        duty = duties[start_index]
        timerange = duty.timeslot.time_range
        span_duty.push(duty)
        colspan += calc_colspan(timerange.start_time, timerange.end_time)
        start_index += 1
      end
      result.push(name: username, colspan: colspan, span_duty: span_duty, free: free, ruid: request_user_id)
      start_index = end_index
      end_index = index_array[next_index]
      next_index += 1
    end
    result
  end

  # rubocop:enable Metrics/LineLength, Metrics/AbcSize, Metrics/MethodLength
end
