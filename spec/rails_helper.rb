ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'database_cleaner'
require 'spec_helper'
require 'rspec/rails'
Capybara.javascript_driver = :webkit
Capybara.server = :puma
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'capybara/webkit/matchers'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Capybara.ignore_hidden_elements = false

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryGirl::Syntax::Methods
  config.include(Capybara::Webkit::RspecMatchers, :type => :feature)
  config.include Warden::Test::Helpers
  Warden.test_mode!
  config.after :each do
    Warden.test_reset!
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
  end
     
  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end
 
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end
 
  config.before(:each) do
    DatabaseCleaner.start
  end
 
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end

RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    page.body.index(earlier_content) < page.body.index(later_content)
  end
end
