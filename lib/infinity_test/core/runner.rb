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
        Core::Base.continuous_test_server.start
      end
    end
  end
end