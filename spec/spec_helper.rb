require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.before :each do
      Mongoid.master.collections.select { |c| c.name !~ /system/ }.each( &:drop )
    end
  end
end

Spork.each_run do
  #Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end
