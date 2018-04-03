# frozen_string_literal: true

module AvailabilitiesHelper
  def generate_cell(day, time_range)
    generate(@availabilities[[day, time_range.id]],
             calc_colspan(time_range.start_time, time_range.end_time))
  end

  def generate(availability, col_span)
    id = availability.id
    td_attributes = { align: 'center', class: 'checkbox_cell',
                      onclick: "toggle(#{id})", id: "cell_#{id}",
                      colspan: col_span }

    content_tag :td, td_attributes do
      check_box_tag "availability_ids[#{id}]", id, availability.status,
                    style: 'visibility: hidden; display: none:'
    end
  end

  def generate_cell_all(day, time_range)
    td_attributes = { class: 'availabilities-all-cell',
                      colspan: calc_colspan(time_range.start_time,
                                            time_range.end_time) }
    content_tag(:td, td_attributes) do
      content_tag(:ol, class: 'availability-list') do
        content_tag(:div) do
          generate_all(@availabilities[[day, time_range.id]])
        end
      end
    end
  end

  def generate_all(availability)
    return '' if availability.empty?
    safe_join(availability.map do |uid|
      user = @users[uid]
      content_tag(:li, title: user[:username],
                       class: 'text-overflow-ellipsis') do
        user[:mc?] ? content_tag(:strong, user[:username]) : user[:username]
      end
    end)
  end

  def generate_cell_dropdown(day_index, time_range)
    @current = @timeslots[[day_index % 7, time_range.id]]
    content_tag(:td, colspan: calc_colspan(time_range.start_time,
                                           time_range.end_time),
                     class: 'availabilities-all-cell') do
      content_tag(:div, style: 'overflow: hidden; text-overflow: ellipsis;') do
        generate_dropdown(day_index, time_range)
      end
    end
  end

  def generate_dropdown(day_index, time_range)
    if @current
      select_tag("#{day_index % 7}#{time_range.id}",
                 options_from_collection_for_select(
                   @current.mc_only ? @users.select(&:mc) : @users,
                   'id', 'username', selected: @current.default_user_id
                 ))
    else '-'
    end
  end
end
