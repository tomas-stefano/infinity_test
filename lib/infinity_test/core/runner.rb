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
        ContinuousTestServer.new(Core::Base).start
      end
    end
  end
end