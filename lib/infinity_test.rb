require 'infinity_test/dependencies'

module InfinityTest
  autoload :Application, 'infinity_test/application'
  autoload :BinaryPath, 'infinity_test/binary_path'
  autoload :Command, 'infinity_test/command'
  autoload :Configuration, 'infinity_test/configuration'
  autoload :ContinuousTesting, 'infinity_test/continuous_testing'
  autoload :Options, 'infinity_test/options'
  autoload :Rspec, 'infinity_test/rspec'
  autoload :Bacon, 'infinity_test/bacon'
  autoload :Runner, 'infinity_test/runner'
  autoload :TestUnit, 'infinity_test/test_unit'

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
