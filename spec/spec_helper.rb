require 'dotenv'
Dotenv.load

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'pry'
require 'Wirecard'


# require 'simplecov'
# require 'coveralls'

# Coveralls.wear!
#
# SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
#   SimpleCov::Formatter::HTMLFormatter,
#   Coveralls::SimpleCov::Formatter
# ]
#
# SimpleCov.start



require 'webmock/rspec'
WebMock.disable_net_connect!(allow: "codeclimate.com")
#allow_localhost: true, 

Dir["./spec/unit_tests/support/**/*.rb"].sort.each { |f| require f}