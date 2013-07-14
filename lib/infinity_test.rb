require 'optparse'
require 'active_support/core_ext'
require 'active_support/deprecation'

module InfinityTest
  module Core
    autoload :AutoDiscover, 'infinity_test/core/auto_discover'
    autoload :Base, 'infinity_test/core/base'
    autoload :CommandBuilder, 'infinity_test/core/command_builder'
    autoload :ConfigurationMerge, 'infinity_test/core/configuration_merge'
    autoload :ContinuousTestServer, 'infinity_test/core/continuous_test_server'
    autoload :LoadConfiguration, 'infinity_test/core/load_configuration'
    autoload :Options, 'infinity_test/core/options'
    autoload :Runner, 'infinity_test/core/runner'
  end

  # This will be removed in the InfinityTest oficial 2.0.1.
  #
  module OldDSL
    autoload :Configuration, 'infinity_test/old_dsl/configuration'
  end

  module Framework
    autoload :Base, 'infinity_test/framework/base'
    autoload :Padrino, 'infinity_test/framework/padrino'
    autoload :Rails, 'infinity_test/framework/rails'
    autoload :Rubygems, 'infinity_test/framework/rubygems'
    autoload :SharedExample, 'infinity_test/framework/shared_example'
  end

  module Observer
    autoload :Base, 'infinity_test/observer/base'
    autoload :Watchr, 'infinity_test/observer/watchr'
    autoload :EventMachine, 'infinity_test/observer/event_machine'
    autoload :SharedExample, 'infinity_test/observer/shared_example'
  end

  module Strategy
    autoload :Base, 'infinity_test/strategy/base'
    autoload :Rbenv, 'infinity_test/strategy/rbenv'
    autoload :Rvm, 'infinity_test/strategy/rvm'
    autoload :RubyDefault, 'infinity_test/strategy/ruby_default'
    autoload :SharedExample, 'infinity_test/strategy/shared_example'
  end

  module TestFramework
    autoload :Base, 'infinity_test/test_framework/base'
    autoload :TestUnit, 'infinity_test/test_framework/test_unit'
    autoload :Rspec, 'infinity_test/test_framework/rspec'
    autoload :Bacon, 'infinity_test/test_framework/bacon'
    autoload :SharedExample, 'infinity_test/test_framework/shared_example'
  end

  # See Core::Base.setup to more information.
  #
  def self.setup(&block)
    InfinityTest::Base.setup(&block)
  end

  include Core
end