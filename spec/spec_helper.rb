require 'pry'
require 'Wirecard'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

Dir["./spec/unit_tests/support/**/*.rb"].sort.each { |f| require f}