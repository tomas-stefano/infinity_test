module InfinityTest
  module Framework
    module Helpers
      # Run all the strategy again.
      #
      def RunAll
      end

      # Run test based on the changed file.
      #
      # @param changed_file [<InfinityTest::Core::ChangedFile>]
      #
      def RunFile(changed_file)
        puts "Changed File Name: #{changed_file.name}"
        puts "Changed File Path: #{changed_file.path}"
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