# frozen_string_literal: true

module Availabilities
  class PlacesController < ApplicationController
    load_and_authorize_resource
    before_action :authenticate_user!

    def index; end

    def edit
      @users = User.order(:id)
      load_availabilities
      load_timeslots
      @disable_viewport = true
    end

    def update
      Timeslot.where(place_id: params[:id]).each do |timeslot|
        update_timeslot(timeslot)
      end
      redirect_to edit_availabilities_place_path(id: params[:id])
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

    def update_timeslot(timeslot)
      selected_user_id = params["#{Availability.days[timeslot.day]}" \
                                "#{timeslot.time_range_id}"]
      return if timeslot.default_user_id == selected_user_id

      timeslot.update(default_user_id: selected_user_id)
    end
  end
end
