# frozen_string_literal: true

module DutiesHelper

	def addDummyDuties(duty_array) 

		TimeRange.all.each do |tr| 
			Place.all.each do |place|
				unless Timeslot.find_by({time_range: tr, place: place})	
					duty_array.each_with_index do |duty_array_for_each_day, index|
						duty_array[index][place.id - 1].insert(tr.id - 1, "dummy")
					end
				end
			end
		end
	end

end
