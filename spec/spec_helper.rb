require 'bundler/setup'
Bundler.require :test
require 'infinity_test'

RSpec.configure do |config|
  config.mock_with :rr
  config.include InfinityTest::Strategy::SharedExample
end