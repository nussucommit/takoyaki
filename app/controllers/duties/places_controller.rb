# frozen_string_literal: true

module Duties
  class PlacesController < ApplicationController
    load_and_authorize_resource
    before_action :authenticate_user!

    def index; end

    def edit
      @start_date = (params[:start_date] || Time.zone.today.beginning_of_week)
                    .to_date
      @end_date = @start_date.to_date + 6.days
      @users = User.order(:username)
      load_availabilities
      load_timeslots
      @disable_viewport = true
    end

    def update
      duty_params.each do |id, user_id|
        Duty.find(id).update(user_id: user_id, free: false, request_user: nil)
      end
      redirect_to edit_duties_place_path(@place),
                  notice: 'Duties successfully updated!'
    end

    private

    def load_availabilities
      @availabilities = Hash.new { |h, k| h[k] = Set[] }
      Availability.where(status: true).each do |a|
        @availabilities[
          [Availability.days[a.day], a.time_range_id]] << a.user_id
      end
    end

    def load_timeslots
      @timeslots = Hash.new { |h, k| h[k] = [] }
      Timeslot.where(place_id: params[:id]).includes(:time_range)
              .each do |timeslot|
        @timeslots[Availability.days[timeslot.day]] << timeslot
      end
    end

    def duty_params
      params.require(:duty)
    end
  end
end
