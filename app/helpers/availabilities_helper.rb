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
    td_attributes = { class: 'availability-all-cell',
                      colspan: calc_colspan(time_range.start_time,
                                            time_range.end_time) }
    content_tag :td, td_attributes do
      generate_all(@availabilities[[day, time_range.id]])
    end
  end

  def generate_all(availability)
    p availability
    return '' if availability.empty?
    availability.map do |uid|
      user = @users[uid]
      if user[:mc?]
        content_tag(:b, user[:username])
      else
        user[:username]
      end
    end.flatten.join(",")
  end
end
