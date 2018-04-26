# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("NUSSU commIT" <duty@#{ENV['MAILGUN_DOMAIN']}>)

  def drop_duty(duty, user_ids)
    @duty = duty
    mail(to: users_with_name(user_ids),
         subject: generate_drop_duty_subject(duty))
  end

  def problem_report(problem)
    @problem = problem
    mail(to: users_with_name(User.where(cell: 'technical').pluck(:id)),
         subject: 'New computer problem')
  end

  private

  def generate_drop_duty_subject(duty)
    'DUTY DUTY DUTY ' \
    "#{duty.time_range.start_time.strftime('%H%M')}-" \
    "#{duty.time_range.end_time.strftime('%H%M')} on " \
    "#{duty.date.strftime('%a, %d %b %Y')} at " \
    "#{duty.place.name}"
  end

  def users_with_name(user_ids)
    User.find(user_ids)&.pluck(:username, :email)&.map do |u|
      %("#{u[0]}" <#{u[1]}>)
    end
  end
end
