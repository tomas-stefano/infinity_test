module InfinityTest
  module Core
    class Runner
      attr_accessor :options

      def initialize(*arguments)
        @options = Options.new(arguments).parse!
      end

      def start
        Core::LoadConfiguration.new.load!
        Core::Base.merge!(options)
        Core::AutoDiscover.new(Core::Base).discover_libraries
        Core::Base.start_continuous_test_server
      end
    end
  end
end