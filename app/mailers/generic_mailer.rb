# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("Mailgun Sandbox" \
    <postmaster@sandbox8f696e611a6e4906a977c007f8971322.mailgun.org>)

  def drop_duty(duty)
    @duty = duty
    mail(to: all_users_with_name,
         subject: 'Duty notification: '\
                  "#{duty.time_range.start_time.strftime('%H%M')}-"\
                  "#{duty.time_range.end_time.strftime('%H%M')} on"\
                  "#{duty.date.strftime('%a, %d %b %Y')} at"\
                  "#{duty.place.name}")
  end

  def problem_report(problem)
    @problem = problem
    mail(to: cell_users_with_name('Technical'),
         subject: 'New computer problem')
  end

  private

  def users_with_name(users)
    users&.pluck(:username, :email)&.map do |u|
      %("#{u[0]}" <#{u[1]}>)
    end
  end

  def all_users_with_name
    users_with_name(User)
  end

  def cell_users_with_name(cell)
    users_with_name(User.find_by(cell: cell))
  end
end
