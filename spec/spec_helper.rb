# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.

  # config.use_transactional_fixtures = true
  
  config.include Devise::TestHelpers, :type => :controller  
  # config.extend ControllerMacros, :type => :controller  

  # run before every test suite
  # config.before do
  #   Courier.create_random 1, :work_state => :available, :number => 1 # Steffan
  #   courier_2 = Courier.create_random 1, :work_state => :available, :number => 2 # Matthias
  #   courier_2.delivery = Delivery.create_from(:munich).state = 'accepted'
  #   Courier.create_random 1, :work_state => :not_available, :number => 3 # Barbie
  # end
end
