module InfinityTest
  module Core
    class ConfigurationMerge
      attr_accessor :base, :options

      delegate :strategy, :rubies, :test_framework, :framework, :to => :options
      delegate :specific_options, :verbose, :bundler, :to => :options

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
        @base.strategy = strategy if strategy.present?
        @base.rubies   = rubies   if rubies.present?
        @base.specific_options = specific_options if specific_options.present?
        @base.test_framework = test_framework if test_framework.present?
        @base.framework = framework if framework.present?
        @base.verbose = verbose unless verbose.nil?
        @base.bundler = bundler unless bundler.nil?
        @base
      end
    end
  end
end