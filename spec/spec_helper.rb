if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'infinity_test'
require 'ostruct'

RSpec.configure do |config|
  config.include InfinityTest::Strategy::SharedExample
  config.include InfinityTest::Observer::SharedExample
  config.include InfinityTest::TestFramework::SharedExample
  config.include InfinityTest::Framework::SharedExample
end

class BaseFixture
  attr_accessor :strategy, :test_framework, :framework

  def initialize(options={})
    @strategy       = options[:strategy]
    @framework      = options[:framework]
    @test_framework = options[:test_framework]
  end
end
