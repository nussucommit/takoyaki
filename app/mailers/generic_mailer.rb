# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("Mailgun Sandbox" \
    <postmaster@sandbox8f696e611a6e4906a977c007f8971322.mailgun.org>)

  def drop_duty(duty)
    @duty = duty
    mail(to: users_with_name(User.all),
         subject: generate_drop_duty_subject(duty))
  end

  def problem_report(problem)
    @problem = problem
    mail(to: users_with_name(Role.find_by(name: :technical).users),
         subject: 'New computer problem')
  end

  private

  def generate_drop_duty_subject(duty)
    'Duty notification: ' \
    "#{duty.time_range.start_time.strftime('%H%M')}-" \
    "#{duty.time_range.end_time.strftime('%H%M')} on" \
    "#{duty.date.strftime('%a, %d %b %Y')} at" \
    "#{duty.place.name}"
  end

  def users_with_name(users)
    users&.pluck(:username, :email)&.map do |u|
      %("#{u[0]}" <#{u[1]}>)
    end
  end
end
