# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("Mailgun Sandbox" <postmaster@sandbox8f696e611a6e4906a977c007f8971322.mailgun.org>)

  def test_email(user)
    @user = user
    puts user.email
    mail(to: @user.email, subject: 'Test Email')
  end
end
