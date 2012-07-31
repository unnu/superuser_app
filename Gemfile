source 'http://rubygems.org'

gem 'rails', "3.2.1"
gem 'jquery-rails'
gem 'haml'
gem 'devise'
gem 'devise_mailchimp'
gem 'jquery_datepicker'
gem 'mysql2'
gem 'airbrake'

group :assets do
  gem 'sass-rails', " ~> 3.2.3"
  gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails', git: 'git://github.com/anjlab/bootstrap-rails.git'
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'launchy'
  gem 'timecop'
  gem 'shoulda'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'forgery'
  gem 'ruby-debug19', require: 'ruby-debug'
  gem 'minitest'
  gem 'database_cleaner'
end

group :development do
  gem 'capistrano'
end

group :production do
  gem 'whenever', require: false
end