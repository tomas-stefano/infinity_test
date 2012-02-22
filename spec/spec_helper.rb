require 'infinity_test'
require 'ostruct'

RSpec.configure do |config|
  config.mock_with :rr
  config.include InfinityTest::Strategy::SharedExample
  config.include InfinityTest::Observer::SharedExample
  config.include InfinityTest::TestFramework::SharedExample
  config.include InfinityTest::Framework::SharedExample
end