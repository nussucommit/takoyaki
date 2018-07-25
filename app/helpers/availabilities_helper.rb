# frozen_string_literal: true

module AvailabilitiesHelper
  CELL_HEIGHT = 80 # height of the table cells in pixels

  def generate_cell(day, time_range)
    generate(@availabilities[[day, time_range.id]])
  end

  def generate(availability)
    id = availability.id
    check_box_tag("availability_ids[#{id}]", id, availability.status,
                  style: 'visibility: hidden;')
  end

  def stylise_user(user)
    if user[:mc]
      content_tag(:span, user[:username], class: 'mc')
    else
      user[:username]
    end
  end

  # rubocop:disable Naming/UncommunicativeMethodParamName
  def generate_select(ts)
    day_index = Availability.days[ts.day]
    time_range_id = ts.time_range_id
    current_users = change(day_index, time_range_id,
                           (ts.mc_only ? @users.select(&:mc) : @users))
    select_tag("#{day_index % 7}#{time_range_id}",
               options_from_collection_for_select(
                 [OpenStruct.new(id: nil, username: '')] + current_users,
                 'id', 'username', selected: ts.default_user_id
               ), class: 'availability-select', onclick: 'enableButtons()')
  end
  # rubocop:enable Naming/UncommunicativeMethodParamName

  def change(day_id, timerange_id, users)
    users.map do |u|
      OpenStruct.new(id: u.id, username: u.username +
        (@availabilities[[day_id, timerange_id]].include?(u.id) ? ' ✓' : ''))
    end
  end

  # rubocop:disable Naming/UncommunicativeMethodParamName
  def calc_offset(tr)
    (CELL_HEIGHT * tr.start_time.seconds_since_midnight / 1.hour).round
  end

  def calc_slot_height(tr)
    (tr.end_time - tr.start_time) / 1.hour * CELL_HEIGHT - 2
  end
  # rubocop:enable Naming/UncommunicativeMethodParamName

  def calc_scroll_availabilities_places
    [(CELL_HEIGHT *
      @timeslots.flat_map(&:second)
      .map { |ts| ts.time_range.start_time.seconds_since_midnight }
      .min / 1.hour).round - CELL_HEIGHT / 2, 0].max
  end

  def calc_scroll_availabilities
    [(CELL_HEIGHT *
      TimeRange.all
      .map { |tr| tr.start_time.seconds_since_midnight }
      .min / 1.hour).round - CELL_HEIGHT / 2, 0].max
  end

  def choose_form_path(path)
    case path
    when 'availabilities/places'
      availabilities_place_path
    when 'availabilities'
      availabilities_path
    end
  end
end
