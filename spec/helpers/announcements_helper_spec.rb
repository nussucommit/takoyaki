# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AnnouncementsHelper. For example:
#
# describe AnnouncementsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AnnouncementsHelper, type: :helper do
  it 'format_time working sucessfully' do
    expect('03 March 2018, 04:04 AM').to eq(format_time(Time.new(
      2018, 3, 3, 4, 4, 0
    ).in_time_zone))
  end
end
