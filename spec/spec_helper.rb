require 'coveralls'
Coveralls.wear!

require 'pry'
require 'Wirecard'

Dir["./spec/**/*_shared.rb"].sort.each { |f| require f}