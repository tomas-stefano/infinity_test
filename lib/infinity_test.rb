require 'optparse'
require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string'
require 'active_support/deprecation'

module InfinityTest
  module Callbacks
    autoload :BaseCallback, 'infinity_test/callbacks/base_callback'
    autoload :AfterCallback, 'infinity_test/callbacks/after_callback'
    autoload :BeforeCallback, 'infinity_test/callbacks/before_callback'
  end

  module Core
    autoload :Base, 'infinity_test/core/base'
    autoload :ConfigurationMerge, 'infinity_test/core/configuration_merge'
    autoload :LoadConfiguration, 'infinity_test/core/load_configuration'
    autoload :Options, 'infinity_test/core/options'
    autoload :Runner, 'infinity_test/core/runner'
  end

  # This will be removed in the InfinityTest 2.0.1 and Extract to a gem
  #
  module OldDSL
    autoload :Configuration, 'infinity_test/old_dsl/configuration'
  end

  module Framework
    autoload :Base, 'infinity_test/framework/base'
    autoload :Padrino, 'infinity_test/framework/padrino'
    autoload :Rails, 'infinity_test/framework/rails'
    autoload :Rubygems, 'infinity_test/framework/rubygems'
  end

  module Observer
    autoload :Base, 'infinity_test/observer/base'
    autoload :Watchr, 'infinity_test/observer/watchr'
  end

  module Strategy
    autoload :AutoDiscover, 'infinity_test/strategy/auto_discover'
    autoload :Base, 'infinity_test/strategy/base'
    autoload :Rbenv, 'infinity_test/strategy/rbenv'
    autoload :Rvm, 'infinity_test/strategy/rvm'
    autoload :RubyDefault, 'infinity_test/strategy/ruby_default'
    autoload :SharedExample, 'infinity_test/strategy/shared_example'
  end

  include Callbacks
  include Core
end