module InfinityTest
  module Framework
    module Helpers
      # Run all the strategy again.
      #
      def RunAll
        continuous_test_server.run_strategy
      end

      # Run test based on the changed file.
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def RunFile(changed_file)
      end

      # Run test based on the changed file.
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def RunTest(changed_file)
      end

      def command_builder
        Core::CommandBuilder.new
      end
    end
  end
end