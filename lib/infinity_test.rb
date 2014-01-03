require 'optparse'
require 'active_support/core_ext'
require 'active_support/deprecation'
require 'hike'

module InfinityTest
  module Core
    autoload :AutoDiscover, 'infinity_test/core/auto_discover'
    autoload :Base, 'infinity_test/core/base'
    autoload :CommandBuilder, 'infinity_test/core/command_builder'
    autoload :CommandRunner,  'infinity_test/core/command_runner'
    autoload :ConfigurationMerge, 'infinity_test/core/configuration_merge'
    autoload :ContinuousTestServer, 'infinity_test/core/continuous_test_server'
    autoload :ChangedFile, 'infinity_test/core/changed_file'
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
    autoload :Helpers, 'infinity_test/framework/helpers'
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
    autoload :SharedExample, 'infinity_test/strategy/shared_example'
  end

  module TestFramework
    autoload :Base, 'infinity_test/test_framework/base'
    autoload :SharedExample, 'infinity_test/test_framework/shared_example'
  end

  # See Core::Base.setup to more information.
  #
  def self.setup(&block)
    InfinityTest::Base.setup(&block)
  end

  include Core
end

require 'infinity_test/strategy/rbenv'
require 'infinity_test/strategy/rvm'
require 'infinity_test/strategy/ruby_default'
require 'infinity_test/framework/padrino'
require 'infinity_test/framework/rails'
require 'infinity_test/framework/rubygems'
require 'infinity_test/test_framework/test_unit'
require 'infinity_test/test_framework/rspec'
require 'infinity_test/test_framework/bacon'
