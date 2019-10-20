# frozen_string_literal: true

module DutiesHelper
  def process_duties(start_date, end_date, first_time, last_time, places)
    all_duties = Duty.includes(:user, :request_user, :time_range)
                     .order('time_ranges.start_time')
    start_date.upto(end_date).map do |day|
      places.map do |place|
        # force eager evaluation to reduce number of SQL queries
        process_day_place(
          all_duties.where(date: day, 'timeslots.place' => place).map { |d| d },
          first_time, last_time
        )
      end
    end
  end

  def current_user_hours(start_date, end_date)
    relevant_duties = Duty.includes(:time_range)
                          .where(user_id: current_user.id,
                                 date: start_date..end_date,
                                 free: false, request_user_id: nil)
    
    sum_hours(relevant_duties)
  end
                              
  def sum_hours(duties)
    total_seconds = duties.map do |d|      
      d.time_range.end_time - d.time_range.start_time
    end.sum
    total_hours = total_seconds / 3600
    total_hours
  end

  private

  def process_day_place(duties, first_time, last_time)
    if duties.empty?
      [{ colspan: calc_colspan(first_time, last_time) }]
    else
      process_duty_prefix(duties, first_time) + process_duty(duties) +
        process_duty_suffix(duties, last_time)
    end
  end

  def process_duty_prefix(duties, first_time)
    result = []
    starting_duty = duties.first.time_range.start_time
    if first_time < starting_duty
      result.push(colspan: calc_colspan(first_time, starting_duty))
    end
    result
  end

  def process_duty_suffix(duties, last_time)
    result = []
    ending_duty = duties.last.time_range.start_time
    if last_time > ending_duty
      result.push(colspan: calc_colspan(ending_duty, last_time))
    end
    result
  end

  def process_duty(duties)
    get_result(duties, get_starting_indices(duties))
  end

  def format_duties(duty_list)
    duty_list.map do |d|
      { id: d.id, timing: d.time_range.start_time.strftime('%H:%M') +
        ' - ' + d.time_range.end_time.strftime('%H:%M'),
        date: d.date, location: d.place.name }
    end
  end

  def should_merge?(prev_duty, current_duty)
    get_duty_status(prev_duty) == get_duty_status(current_duty)
  end

  def get_duty_status(duty)
    if duty&.free
      [duty&.free, duty&.request_user]
    else
      [duty&.free, duty&.user_id]
    end
  end

  def get_starting_indices(duties)
    index_array = [0]
    duties.length.times.each_cons(2).select do |prev, current|
      next if should_merge?(duties[prev], duties[current])

      index_array.push(current)
    end
    index_array.push(duties.length)
  end

  # rubocop:disable Metrics/LineLength, Metrics/AbcSize
  def get_result(duties, index_array)
    result = []
    start_index, end_index = *index_array
    (2..index_array.length).each do |next_index|
      span_duty = duties[start_index, end_index - start_index]
      colspan = span_duty.map do |duty|
        calc_colspan(duty.time_range.start_time, duty.time_range.end_time)
      end.sum
      result.push(user: duties[start_index]&.user, colspan: colspan, span_duty: span_duty,
                  free: duties[start_index].free,
                  request_user_id: duties[start_index]&.request_user_id)
      start_index = end_index
      end_index = index_array[next_index]
    end
    result
  end
  # rubocop:enable Metrics/LineLength, Metrics/AbcSize

  def generate_select_duties(duty)
    select_tag("duty[#{duty.id}]",
               options_from_collection_for_select(
                 [OpenStruct.new(id: nil, username: '')] + @users,
                 'id', 'username', selected: duty.user_id
               ), class: 'availability-select', onchange: 'enableButtons()')
  end
end
