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
    prev_start = nil
    prev_end = nil
    new_duties = []
    duties.map do |duty|
      prev_start, prev_end =
        combine_duties_times(duty, new_duties, prev_start, prev_end)
    end
    new_duties.push("#{prev_start}-#{prev_end}")
    new_duties.join(', ')
  end

  def combine_duties_times(duty, new_duties, prev_start, prev_end)
    start_time = duty.time_range.start_time.strftime('%H%M')
    end_time = duty.time_range.end_time.strftime('%H%M')
    if prev_end && prev_end != start_time
      new_duties.push("#{prev_start}-#{prev_end}")
      [start_time, end_time]
    else
      [prev_start || start_time, end_time]
    end
  end

  def mc_only?
    Setting.retrieve.mc_only
  end

  def process_user_ids(user_ids)
    user_ids = User.where('id in (?) and receive_email = TRUE', user_ids).pluck(:id)
    if mc_only?
      User.where('id in (?) and mc = TRUE', user_ids).pluck(:id)
    else
      user_ids
    end
  end
end
