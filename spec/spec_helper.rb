require 'coveralls'
Coveralls.wear!

require 'pry'
require 'Wirecard'

Dir["./spec/unit_tests/support/**/*.rb"].sort.each { |f| require f}