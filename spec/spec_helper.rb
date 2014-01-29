if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'infinity_test'
require 'ostruct'
Bundler.require

RSpec.configure do |config|
  config.include InfinityTest::Strategy::SharedExample
  config.include InfinityTest::Observer::SharedExample
  config.include InfinityTest::TestFramework::SharedExample
  config.include InfinityTest::Framework::SharedExample

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class BaseFixture
  attr_accessor :strategy, :test_framework, :framework

  def initialize(options={})
    @strategy       = options[:strategy]
    @framework      = options[:framework]
    @test_framework = options[:test_framework]
  end
end
