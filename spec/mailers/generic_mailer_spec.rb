# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenericMailer, type: :mailer do
  DEFAULT_FROM =
    'postmaster@sandbox8f696e611a6e4906a977c007f8971322.mailgun.org'

  describe '#drop_duty' do
    let(:mail) do
      user = create(:user)
      timeslot = create(:timeslot)
      @duty = create(:duty, user: user, timeslot: timeslot)
      GenericMailer.drop_duty(@duty)
    end

    it 'renders the header' do
      expect(mail.subject).to eq(
        'Duty notification: '\
        "#{@duty.time_range.start_time.strftime('%H%M')}-"\
        "#{@duty.time_range.end_time.strftime('%H%M')} on"\
        "#{@duty.date.strftime('%a, %d %b %Y')} at"\
        "#{@duty.place.name}"
      )
      expect(mail.to).to eq(User.pluck(:email))
      expect(mail.from).to eq([DEFAULT_FROM])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('grab')
      # expect(mail.body.encoded).to match(dropped_duties_url)
    end
  end

  # TODO: uncomment after problem-report is merged
  #  describe '#problem_report' do
  #    let(:mail) do
  #      user = create(:user)
  #      @problem = create(:problem, user: user)
  #      GenericMailer.problem_report(@problem)
  #    end
  #    it 'renders the header' do
  #      expect(mail.subject).to eq('New computer problem')
  #      expect(mail.to).to eq(User.find_by(cell: Technical).pluck(:email))
  #      expect(mail.from).to eq([DEFAULT_FROM])
  #    end
  #    it 'renders the body' do
  #      expect(mail.body.encoded).to match('problem')
  #    end
  #  end
end
