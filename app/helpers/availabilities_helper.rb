# frozen_string_literal: true

module AvailabilitiesHelper
  def get_colspan(time_range_id)
    time_range = TimeRange.find_by(id: time_range_id)
    ((time_range.end_time - time_range.start_time) / 0.5.hours).round
  end

  def generate_cell(availability)
    content_tag :td, align: 'center', class: 'checkbox_cell',
                     onclick: "toggle(#{availability.id})",
                     id: "cell_#{availability.id}",
                     colspan: get_colspan(availability.time_range_id) do
      check_box_tag 'availability_ids[]', availability.id,
                    availability.status,
                    style: 'visibility: hidden; display: none:'
    end
  end
end
