# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  before_action :set_up_mail_variables, only: %i[drop_duties problem_report]

  def drop_duties(duties, user_ids)
    drop_duties_variables(duties)

    @mb_obj.subject(generate_drop_duty_subject_detailed(@times, @date, @venue))
    html_output = render_to_string template: 'generic_mailer/drop_duties'
    @mb_obj.body_html(html_output)

    users_with_name(user_ids).each do |u|
      @mb_obj.add_recipient(:to, u[1], 'first' => u[0])
    end

    @mb_obj.finalize
  end

  def problem_report(problem)
    @problem = problem

    @mb_obj.subject('New Computer Problem')
    html_output = render_to_string template: 'generic_mailer/problem_report'
    @mb_obj.body_html(html_output)

    users_with_name(User.where(cell: 'technical').pluck(:id)).each do |u|
      @mb_obj.add_recipient(:to, u[1], 'first' => u[0])
    end

    @mb_obj.finalize
  end

  private

  def set_up_mail_variables
    @mg_client = Mailgun::Client.new(ENV['MAILGUN_API_KEY'])
    @mb_obj = Mailgun::BatchMessage.new(@mg_client, ENV['MAILGUN_DOMAIN'])
    @mb_obj.from("duty@#{ENV['MAILGUN_DOMAIN']}", 'first' => 'NUSSU commIT')
  end

  def drop_duties_variables(duties)
    @from = duties.first.user.username
    @date = duties.first.date
    @times = process_duties_times(duties)
    @venue = duties.first.place.name
  end

  def generate_drop_duty_subject_detailed(times, date, venue)
    'DUTY DUTY DUTY ' \
    "#{date.strftime('%a, %d %b %Y')}, " \
    "#{times} at " \
    "#{venue}"
  end

  def users_with_name(user_ids)
    User.find(user_ids)&.pluck(:username, :email)
  end

  def process_duties_times(duties)
    duties.map do |duty|
      "#{duty.time_range.start_time.strftime('%H%M')}-" \
      "#{duty.time_range.end_time.strftime('%H%M')}"
    end.join(', ')
  end
end
