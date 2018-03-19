# frozen_string_literal: true

module AvailabilitiesHelper
  def get_colspan(time_range)
    ((time_range.end_time - time_range.start_time) / 0.5.hours).round
  end

  def generate_cell(day, time_range)
    generate(@availabilities[[day, time_range.id]], get_colspan(time_range))
  end

  def generate(availability, col_span)
    content_tag :td, align: 'center', class: 'checkbox_cell',
                     onclick: "toggle(#{availability.id})",
                     id: "cell_#{availability.id}",
                     colspan: col_span do
      check_box_tag 'availability_ids[]', availability.id,
                    availability.status,
                    style: 'visibility: hidden; display: none:'
    end
  end
end
