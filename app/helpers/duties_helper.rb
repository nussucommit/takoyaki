# frozen_string_literal: true

module DutiesHelper

  def process_duties(start_date, end_date)
    start_date.upto(end_date).map do |day| 
    	Place.all.map do |place| 
    		process_day_place(day, place)
    	end
    end
  end

  private 

  def process_day_place(day, place)

    result = []
    duties = Duty.where(date: day)
                 .joins(:timeslot).where('timeslots.place' => place)
                 .ordered_by_start_time.includes(:timeslot, :user)
               	 .to_a
    if duties.empty?
    	return [{ name: nil, colspan: ((TimeRange.last.end_time - TimeRange.first.start_time) / (0.5).hour).round }] 
    else

    	starting_time = TimeRange.first.start_time
    	starting_duty = duties.first.timeslot.time_range.start_time
    	if starting_time < starting_duty
	    	result.push({name: nil, colspan: ((starting_duty - starting_time) / 0.5.hour).round})
	    end

	    result += process_duty(duties)

	    ending_time = TimeRange.last.start_time
    	ending_duty = duties.last.timeslot.time_range.start_time
	    if ending_time > ending_duty
	    	result.push({name: nil, colspan: ((ending_time - ending_duty) / 0.5.hour).round})
			end

	   	return result
	   	
	  end

  end

  private 

  def process_duty(duties)
  	colspan = 0
  	result = []
    duties.each_with_index do |duty, index|
    	colspan += ((duty.timeslot.time_range.end_time - duty.timeslot.time_range.start_time) / 0.5.hour).round
      unless duties[index]&.user&.email == duties[index + 1]&.user&.email
        result.push({ name: duty.user.email, colspan: colspan })
        colspan = 0
      end
    end
    result
  end

end
