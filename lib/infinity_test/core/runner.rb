module InfinityTest
  module Core
    class Runner
      attr_accessor :options, :base, :configuration

      def initialize(*arguments)
        @options = Options.new(arguments).parse!
        @base    = Core::Base
        @configuration = Core::LoadConfiguration.new
      end

      def start!
        @configuration.load!
        @base.merge!(@options)
        @base.run_strategy!
        @base.start_observer
      end
    end
  end
end