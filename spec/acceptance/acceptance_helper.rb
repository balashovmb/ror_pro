require 'rails_helper'
require 'capybara/email/rspec'

OmniAuth.config.test_mode = true

#Capybara.default_max_wait_time  = 5
Capybara.ignore_hidden_elements = true

RSpec.configure do |config|

  Capybara.javascript_driver = :webkit
  
  Capybara.server = :puma

  config.use_transactional_fixtures = false

  config.include AcceptanceHelper, type: :feature

  config.include OmniauthMacros

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end