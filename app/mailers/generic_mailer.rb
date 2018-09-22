# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("NUSSU commIT" <duty@#{ENV['MAILGUN_DOMAIN']}>)

  def drop_duties(duties, user_ids)
    @from = duties.first.user.username
    @date = duties.first.date
    @times = process_duties_times(duties)
    @venue = duties.first.place.name
    users_with_name(user_ids).each do |u| headers['to'] = u end
    headers['recipient-variables'] = '{}'
    mail(subject: generate_drop_duty_subject_detailed(@times, @date, @venue))
  end

  def problem_report(problem)
    @problem = problem
    users_with_name(User.where(cell: 'technical').pluck(:id)).each do |u|
      headers['to'] = u
    end
    headers['recipient-variables'] = '{}'
    mail(subject: 'New computer problem')
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
    duties.map do |duty|
      "#{duty.time_range.start_time.strftime('%H%M')}-" \
      "#{duty.time_range.end_time.strftime('%H%M')}"
    end.join(', ')
  end
end
