# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("NUSSU commIT" <duty@#{ENV['MAILGUN_DOMAIN']}>)

  def drop_duties(duties, user_ids)
    @from = duties.first.user.username
    @date = duties.first.date
    # Prevent (n + 1) queries
    @times = process_duties_times(
      Duty.includes(:time_range).find(duties.map(&:id))
    )
    @venue = duties.first.place.name
    mail(to: users_with_name(process_user_ids(user_ids)),
         subject: generate_drop_duty_subject_detailed(@times, @date, @venue))
  end

  def problem_report(problem)
    @problem = problem
    mail(to: users_with_name(User.where(cell: 'technical').pluck(:id)),
         subject: 'New computer problem')
  end

  private

  def generate_drop_duty_subject_detailed(times, date, venue)
    'DUTY DUTY DUTY ' \
    "#{date.strftime('%a, %d %b %Y')}, " \
    "#{times} at " \
    "#{venue}"
  end

  def users_with_name(user_ids)
    User.find(user_ids)&.pluck(:username, :email)&.map do |u|
      %("#{u[0]}" <#{u[1]}>)
    end
  end

  def process_duties_times(duties)
    @prev_start = nil
    @prev_end = nil
    @new_duties = []
    duties.map do |duty|
      combine_duties_times(duty, duty == duties.last)
    end
    duties = @new_duties.join(', ')
  end

  def combine_duties_times(duty, is_last)
    start_time = duty.time_range.start_time.strftime('%H%M').to_s
    end_time = duty.time_range.end_time.strftime('%H%M').to_s
    if @prev_end && @prev_end != start_time
      @new_duties.push("#{@prev_start}-#{@prev_end}")
      @prev_start = start_time
      @prev_end = end_time
    else
      @prev_start ||= start_time
      @prev_end = end_time
      @new_duties.push("#{@prev_start}-#{@prev_end}") if is_last
    end
  end

  def mc_only?
    Setting.retrieve.mc_only
  end

  def process_user_ids(user_ids)
    if mc_only?
      User.where('id in (?) and mc = TRUE', user_ids).pluck(:id)
    else
      user_ids
    end
  end
end
