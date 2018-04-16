# frozen_string_literal: true

module AvailabilitiesHelper
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
      content_tag(:strong, user[:username])
    else
      user[:username]
    end
  end

  def generate_select(ts)
    day_index = Availability.days[ts.day]
    time_range_id = ts.time_range_id
    current_users = change(day_index, time_range_id,
                           (ts.mc_only ? @users.select(&:mc) : @users))
    select_tag("#{day_index % 7}#{time_range_id}",
               options_from_collection_for_select(
                 current_users,
                 'id', 'username', selected: ts.default_user_id
               ), class: 'availability-select')
  end

  def change(day_id, timerange_id, users)
    users.map do |u|
      OpenStruct.new(id: u.id, username: u.username +
        (@availabilities[[day_id, timerange_id]].include?(u.id) ? ' ✓' : ''))
    end
  end

  def calc_offset(tr)
    (80.0 * tr.start_time.seconds_since_midnight / 1.hour).round
  end

  def calc_slot_height(tr)
    (tr.end_time - tr.start_time) / 1.hour * 80 - 2
  end

  def calc_scroll
    [(80.0 *
      @timeslots.map(&:second)
      .flat_map { |x| x }
      .map { |ts| ts.time_range.start_time.seconds_since_midnight }
      .min / 1.hour).round - 40, 0].max
  end

  def calc_scroll_2
    [(80.0 *
      TimeRange.all
      .map { |tr| tr.start_time.seconds_since_midnight }
      .min / 1.hour).round - 40, 0].max
  end
end
