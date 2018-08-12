# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("NUSSU commIT" <duty@#{ENV['MAILGUN_DOMAIN']}>)

  def drop_duties(duties, user_ids)
    @from = duties.first.user.username
    @date = duties.first.date
    @start_time = duties.first.time_range.start_time
    @end_time = duties.last.time_range.end_time
    @venue = duties.first.place.name
    mail(to: users_with_name(user_ids),
         subject: generate_drop_duty_subject_detailed(@start_time, @end_time,
                                                      @date, @venue))
  end

  def problem_report(problem)
    @problem = problem
    mail(to: users_with_name(User.where(cell: 'technical').pluck(:id)),
         subject: 'New computer problem')
  end

  private

  def generate_drop_duty_subject_detailed(start_time, end_time, date, venue)
    'DUTY DUTY DUTY ' \
    "#{start_time.strftime('%H%M')}-" \
    "#{end_time.strftime('%H%M')} on " \
    "#{date.strftime('%a, %d %b %Y')} at " \
    "#{venue}"
  end

  def users_with_name(user_ids)
    User.find(user_ids)&.pluck(:username, :email)&.map do |u|
      %("#{u[0]}" <#{u[1]}>)
    end
  end
end
