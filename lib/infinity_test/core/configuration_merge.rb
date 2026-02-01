module InfinityTest
  module Core
    class ConfigurationMerge
      attr_accessor :base, :options

      delegate :strategy, :rubies, :test_framework, :framework, :to => :options
      delegate :specific_options, :infinity_and_beyond, :verbose, :bundler, :to => :options
      delegate :notifications, :mode, :to => :options

      def initialize(base, options)
        @base = base
        @options = options
      end

      # Execute the merge between base and command line options
      #
      # === Returns
      # <Core::BaseClass>: The infinity test core base class.
      #
      def merge!
        @base.strategy            = strategy if strategy.present?
        @base.rubies              = rubies unless rubies.nil?
        @base.specific_options    = specific_options if specific_options.present?
        @base.test_framework      = test_framework if test_framework.present?
        @base.framework           = framework if framework.present?
        @base.infinity_and_beyond = infinity_and_beyond unless infinity_and_beyond.nil?
        @base.verbose             = verbose unless verbose.nil?
        @base.bundler             = bundler unless bundler.nil?
        @base.notifications       = notifications if notifications.present?
        @base.mode                = mode if mode.present?
        @base
      end
    end
  end
end