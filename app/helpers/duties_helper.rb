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
    get_result(duties, get_index_array(duties))
  end

  def format_duties(duty_list)
    duty_list.map do |d|
      { id: d.id, timing: d.timeslot.time_range.start_time.strftime('%H:%M') +
        ' - ' + d.timeslot.time_range.end_time.strftime('%H:%M') }
    end
  end

  def check_condition(prev_duty, current_duty)
    prev_duty&.free != current_duty&.free ||
      (!prev_duty&.free && !current_duty&.free &&
        ((!prev_duty.request_user_id.nil? &&
          prev_duty&.request_user_id != current_duty&.request_user_id) ||
        prev_duty&.user_id != current_duty&.user_id))
  end

  def get_index_array(duties)
    index_array = [0]
    duties.length.times.each_cons(2).select do |prev, current|
      next unless check_condition(duties[prev], duties[current])
      index_array.push(current)
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
      result.push(user: duties[start_index]&.user, colspan: colspan, span_duty: span_duty,
                  free: duties[start_index].free,
                  request_user_id: duties[start_index]&.request_user_id)
      start_index = end_index
      end_index = index_array[next_index]
    end
    result
  end

  # rubocop:enable Metrics/LineLength, Metrics/AbcSize, Metrics/MethodLength

  def generate_select_duties(duty)
    select_tag("duty[#{duty.id}]",
               options_from_collection_for_select(
                 @users,
                 'id', 'username', selected: duty.user_id
               ), class: 'availability-select', onclick: 'enableButtons()')
  end
end
