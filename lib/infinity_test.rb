require 'infinity_test/dependencies'

module InfinityTest
  autoload :Application, 'infinity_test/application'
  autoload :BinaryPath, 'infinity_test/binary_path'
  autoload :Command, 'infinity_test/command'
  autoload :Configuration, 'infinity_test/configuration'
  autoload :ContinuousTesting, 'infinity_test/continuous_testing'
  autoload :Options, 'infinity_test/options'
  autoload :Runner, 'infinity_test/runner'
  autoload :TestFramework, 'infinity_test/test_framework'
  autoload :Rails , 'infinity_test/rails'

  module TestLibrary
    autoload :Bacon, 'infinity_test/test_library/bacon'
    autoload :Rspec, 'infinity_test/test_library/rspec'
    autoload :TestUnit, 'infinity_test/test_library/test_unit'
  end

  module Notifications
    autoload :Growl, 'infinity_test/notifications/growl'
    autoload :LibNotify, 'infinity_test/notifications/lib_notify'
  end

  def self.application
    @application ||= Application.new
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.start!
    Runner.new(ARGV).run!
  end

end
