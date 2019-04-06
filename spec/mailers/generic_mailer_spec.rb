# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenericMailer, type: :mailer do
  describe '#drop_duties' do
    let(:duties) do
      user = create(:user)
      @duties = (8..12)
                .map { |n| format('%2d:00', n).in_time_zone }
                .map do |start_time|
                  create(:time_range, start_time: start_time,
                                      end_time: start_time + 1.hour)
                end
                .map { |tr| create(:timeslot, time_range: tr) }
                .map { |ts| create(:duty, user: user, timeslot: ts) }
    end

    let(:mail) do
      GenericMailer.drop_duties(duties, User.pluck(:id))
    end

    it 'renders the header' do
      times = '0800-1300'

      expect(mail.subject).to eq(
        'DUTY DUTY DUTY ' \
        "#{@duties.first.date.strftime('%a, %d %b %Y')}, " \
        "#{times} at " \
        "#{@duties.first.place.name}"
      )
      expect(mail.to).to eq(User.pluck(:email))
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('grab')
    end

    it 'follows mc_only flag' do
      create_list(:user, 5, mc: false)
      create_list(:user, 5, mc: true)
      Setting.retrieve.update(mc_only: true)
      expect(mail.to).to eq(User.select(&:mc).pluck(:email))
    end
  end

  describe '#combine_duties' do
    let(:duties) do
      user = create(:user)
      @duties = (8, 9, 12, 13)
                .map { |n| format('%2d:00', n).in_time_zone }
                .map do |start_time|
                  create(:time_range, start_time: start_time,
                                      end_time: start_time + 1.hour)
                end
                .map { |tr| create(:timeslot, time_range: tr) }
                .map { |ts| create(:duty, user: user, timeslot: ts) }
    end

    let(:mail) do
      GenericMailer.drop_duties(duties, User.pluck(:id))
    end

    it 'renders the header' do
      times = '0800-1000,1200-1400'

      expect(mail.subject).to eq(
        'DUTY DUTY DUTY ' \
        "#{@duties.first.date.strftime('%a, %d %b %Y')}, " \
        "#{times} at " \
        "#{@duties.first.place.name}"
      )
      expect(mail.to).to eq(User.pluck(:email))
    end
  end

  describe '#problem_report' do
    let(:mail) do
      user = create(:user, cell: 'technical')
      problem = create(:problem_report, reporter_user: user)
      GenericMailer.problem_report(problem)
    end
    it 'renders the header' do
      expect(mail.subject).to eq('New computer problem')
      expect(mail.to).to eq(User.where(cell: 'technical').pluck(:email))
    end
    it 'renders the body' do
      expect(mail.body.encoded).to match('problem')
    end
  end
end
