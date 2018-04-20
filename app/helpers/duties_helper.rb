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

  def check_condition(span_free, span_user_id, span_request_user_id, current_duty)
    span_free != current_duty.free || (!span_free && !current_duty.free && ((!span_request_user_id.nil? && span_request_user_id != current_duty&.request_user_id) || span_user_id != current_duty&.user&.id))
  end

  def get_index_array(duties)
    index_array = [0]
    span_free = duties[0].free
    span_user_id = duties[0]&.user&.id
    span_request_user_id = duties[0]&.request_user_id
    (1..(duties.length - 1)).each do |index|
      current_duty = duties[index]
      next unless check_condition(span_free, span_user_id, span_request_user_id, current_duty)
      index_array.push(index)
      span_free = current_duty.free
      span_user_id = current_duty&.user&.id
      span_request_user_id = current_duty&.request_user_id
    end
    index_array.push(duties.length)
  end

  def get_result(duties, index_array)
    result = []
    start_index, end_index = *index_array
    (2..index_array.length).each do |next_index|
      span_duty = duties[start_index, end_index - start_index]
      colspan = span_duty.map do |duty|
        calc_colspan(duty.timeslot.time_range.start_time, duty.timeslot.time_range.end_time)
      end.sum
      result.push(name: duties[start_index]&.user&.username, colspan: colspan, span_duty: span_duty,
                  free: duties[start_index].free, ruid: duties[start_index]&.request_user_id)
      start_index = end_index
      end_index = index_array[next_index]
    end
    result
  end

  def process_duty(duties)
    get_result(duties, get_index_array(duties))
  end

  # rubocop:enable Metrics/LineLength, Metrics/AbcSize, Metrics/MethodLength
end
