require 'dotenv'
Dotenv.load

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'pry'
require 'wirecard'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true, allow: 'codeclimate.com')

Dir["./spec/unit_tests/support/**/*.rb"].sort.each { |f| require f}