# frozen_string_literal: true

require 'set'

class AvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, except: %i[index update_availabilities]

  def index
    @time_ranges = TimeRange.order(:start_time)
    @availabilities = load_availabilities
    create_missing_availabilities
    @start_time = start_time
    @end_time = end_time
  end

  def update_availabilities
    availability_ids = params[:availability_ids] || []
    Availability.where(user: current_user).each do |availability|
      available = availability_ids.include?(availability.id.to_s)
      availability.update(status: available) if availability.status != available
    end
    redirect_to availabilities_path
  end

  def show_everyone
    @time_ranges = TimeRange.order(:start_time)
    @availabilities = load_all_availabilities
    @users = load_all_users
    @start_time = start_time
    @end_time = end_time
  end

  private

  def load_all_availabilities
    result = {}
    Availability.joins(:time_range)
                .order(:day, 'time_ranges.start_time')
                .each do |a|
      result[[a.day, a.time_range_id]] ||= []
      result[[a.day, a.time_range_id]].push(a.user_id) if a.status
    end
    result
  end

  def load_all_users
    mc = load_mcs
    Hash[
      User.all.map do |u|
        [u.id, { username: u.username, mc?: mc.include?(u.id) }]
      end
    ]
  end

  def load_mcs
    managers = Role.find_by(name: :manager)&.users&.map(&:id)
    if managers.nil?
      Set[]
    else
      Set.new(managers)
    end
  end

  def load_availabilities
    Hash[Availability.where(user: current_user).joins(:time_range)
                     .order('day', 'time_ranges.start_time')
                     .map do |availability|
           [[availability.day, availability.time_range_id], availability]
         end
    ]
  end

  def create_missing_availabilities
    Availability.days.each_key do |day|
      @time_ranges.each do |time_range|
        next if @availabilities.key?([day, time_range.id])
        @availabilities[[day, time_range.id]] = Availability.create(
          user: current_user, day: day,
          time_range_id: time_range.id, status: false
        )
      end
    end
  end

  def start_time
    @time_ranges.first.start_time.beginning_of_hour
  end

  def end_time
    (@time_ranges.last.end_time - 1).beginning_of_hour + 1.hour
  end

  def check_admin
    redirect_to availabilities_path unless current_user.has_role?(:admin)
  end
end
