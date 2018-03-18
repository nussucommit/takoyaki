# frozen_string_literal: true

module AvailabilitiesHelper
  def get_colspan(time_range_id)
    time_range = TimeRange.find_by(id: time_range_id)
    ((time_range.end_time - time_range.start_time) / 0.5.hours).round
  end

  def generate_cell(availability)
    id = availability.id
    time_range = availability.time_range

    td_attributes = { align: 'center', class: 'checkbox_cell',
                      onclick: "toggle(#{id})", id: "cell_#{id}",
                      colspan: calc_colspan(time_range.start_time,
                                            time_range.end_time) }
    content_tag :td, td_attributes do
      check_box_tag "availability_ids[#{id}]", id, availability.status,
                    style: 'visibility: hidden; display: none:'
    end
  end
end
