require 'infinity_test/dependencies'

module InfinityTest
  autoload :Application, 'infinity_test/application'
  autoload :BinaryPath, 'infinity_test/binary_path'
  autoload :Builder, 'infinity_test/builder'
  autoload :Command, 'infinity_test/command'
  autoload :Configuration, 'infinity_test/configuration'
  autoload :ContinuousTesting, 'infinity_test/continuous_testing'
  autoload :Environment, 'infinity_test/environment'
  autoload :Heuristics, 'infinity_test/heuristics'
  autoload :HeuristicsHelper, 'infinity_test/heuristics_helper'
  autoload :Options, 'infinity_test/options'
  autoload :Runner, 'infinity_test/runner'
  autoload :TestFramework, 'infinity_test/test_framework'

  module ApplicationLibrary
    autoload :Rails , 'infinity_test/application_library/rails'
    autoload :RubyGems, 'infinity_test/application_library/rubygems'
  end

  module TestLibrary
    autoload :Bacon, 'infinity_test/test_library/bacon'
    autoload :Cucumber, 'infinity_test/test_library/cucumber'
    autoload :Rspec, 'infinity_test/test_library/rspec'
    autoload :TestUnit, 'infinity_test/test_library/test_unit'
  end

  def self.application
    @application ||= Application.new
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.watchr
    @watchr ||= Watchr::Script.new
  end

  def self.start!
    Runner.new(ARGV).run!
  end

end
