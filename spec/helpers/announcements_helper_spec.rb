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
    today = Time.zone.now.strftime('%d %B %C%y, %I:%M %p')
    expect(today).to eq(format_time(Time.zone.now))
  end
end
