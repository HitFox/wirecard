# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wirecard/version'

Gem::Specification.new do |spec|
  spec.name          = "wirecard"
  spec.version       = Wirecard.version
  spec.authors       = ["Dominic Breuker", "Michael Rüffer"]
  spec.email         = ["dominic.breuker@gmail.com", "mr@hitfoxgroup.com"]
  spec.summary       = "Wirecard API wrapper"
  spec.description   = "Implements the Wirecard API for payment services. Currently supports only seamless mode."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pry"
end
