require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end
require 'minitest/autorun'
require 'mocha/mini_test'
require 'capybara/minitest'
require 'lib/csv_controller'
require 'lib/translator'
require 'app'

# class describe capybara app test cases
class CapybaraTestCase < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
