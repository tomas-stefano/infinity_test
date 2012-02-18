require 'infinity_test'

RSpec.configure do |config|
  config.mock_with :rr
  config.include InfinityTest::Strategy::SharedExample
  config.include InfinityTest::Observer::SharedExample
end