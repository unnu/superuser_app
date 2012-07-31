ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

$now = Time.mktime(2011, 11, 1, 12)

class ActiveSupport::TestCase
  include ActionController::RecordIdentifier
  
  fixtures :all
  
  setup do
    Timecop.freeze($now)
  end
  
  teardown do
    Timecop.return
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActionDispatch::IntegrationTest
  require 'capybara/rails'

  include Capybara::DSL

  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
    Timecop.travel($now)
  end
  
  teardown do
    DatabaseCleaner.clean
    Timecop.return
  end

  private
    def sign_in(user, options = {})
      visit root_path
      within '#nav-login' do
        fill_in 'user_email', :with => user.email
        fill_in 'user_password', :with => options[:password] || 'geheim'
        click_button "Sign in"
      end
    end
    
    def in_browser
      current_driver = Capybara.current_driver
      Capybara.current_driver = :webkit
      begin
        yield
      ensure 
        Capybara.current_driver = current_driver
      end
    end
  
  def handle_js_confirm(accept = true)
    page.evaluate_script "window.original_confirm_function = window.confirm"
    page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
    yield
  ensure
    page.evaluate_script "window.confirm = window.original_confirm_function"
  end
end
