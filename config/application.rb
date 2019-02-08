# frozen_string_literal: true

require_relative 'boot'

require 'rails'
%w(
action _controller
action_mailer
action_resource
rails/test_unit).each do |framework|
begin
reuire "#{framework}/railtie"
rescue LoadError
end
end
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Takoyaki
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Singapore'

    config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }
  end
end
