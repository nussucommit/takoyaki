source 'https://rubygems.org'

### BASICS

# Ruby version
ruby '2.6.0'
# Rails version
gem 'rails', '~> 5.2', '>= 5.2.3'
# Use postgres as database
gem 'pg'
# Use Puma as the app server
gem 'puma'
# For Travis CI
gem 'rake', group: :test
# Make loading large Ruby/Rails apps faster
gem 'bootsnap', require: false

### END BASICS

### VIEWS, ASSETS, FRONTEND STUFF

# Use SCSS for stylesheets
gem 'sassc-rails', '>= 2.1.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use jQuery
gem 'jquery-rails', '>= 4.4.0'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks', '>= 2.1.0'
# Use Bootstrap, the CSS framework (getbootstrap.com)
gem 'bootstrap', '>= 4.3.1'
# Javascript interpreter
# therubyracer contains too old JS runtime
# gem 'therubyracer', platforms: :ruby
gem 'mini_racer', platforms: :ruby

group :development do
  # Favicon set
  gem 'rails_real_favicon', '>= 0.1.0'
  # Generate Entity-Relationship Diagram
  gem 'rails-erd', require: false
end

### END ASSETS

### UTILITIES

# Environment variables
gem 'dotenv-rails', '>= 2.7.5', require: 'dotenv/rails-now'
# Mailgun
gem 'mailgun-ruby', '~> 1.2.0'
# Excel (XLSX) importing
gem 'axlsx_rails', '>= 0.6.1'
# Axlsx dependency
gem 'rubyzip', '>= 1.2.1'
# Axlsx dependency
gem 'caxlsx', '>= 3.0.1'
# Force loofah update
gem 'loofah', '>= 2.5.0'

group :test do
  # Test coverage
  gem 'coveralls', require: false
end

group :development do
  # Annotates model with schema
  gem 'annotate'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.7.0'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Shoot those n+1 queries!
  gem 'bullet'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a
  # debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Rspec testing framework
  gem 'rspec-rails', '>= 4.0.1'
  # Factory bot: factories for testing
  gem 'factory_bot_rails', '>= 6.1.0'
  # Shoulda Matchers: matchers for testing -- experimental gem for Rails 5
  gem 'shoulda-matchers', '~> 4.3'
  # Trace routes
  gem 'traceroute', '>= 0.8.1'
  # For assert_template (check if view is rendered)
  gem 'rails-controller-testing', '>= 1.0.4'
end

### END UTILITIES

### QUALITY

group :development, :test do
  # Ruby linter
  gem 'rubocop'
  gem 'rubocop-rspec'
  # SCSS linter
  gem 'scss_lint', require: false
end

### END QUALITY

### MAINTENANCE

# Add browser info in logs
gem 'browser_details'

group :development, :production do
  # Database profiler
  gem 'rack-mini-profiler'
  # Auto-email exceptions
  gem 'exception_notification', '>= 4.4.0'
end

group :production do
  # Sitemap generator
  gem 'sitemap_generator'
end

### END MAINTENANCE

### SECURITY

# Adds authentication
gem 'devise', '>= 4.7.1'
# Adds roles
gem 'rolify'
# Adds privileges
gem 'cancancan'
# Adds various security stuff. You need protection!
gem 'rack-protection'

group :development, :test do
  # Security checkup
  gem 'brakeman'
end

### END SECURITY
