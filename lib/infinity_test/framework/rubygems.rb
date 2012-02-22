module InfinityTest
  module Framework
    class Rubygems < Base
      def heuristics
        # @observer.watch_dir('lib') do |file|
        #   RunTest.new(file)
        # end
        #
        # @observer.watch_dir(@test_framework.test_dir) do |file|
        #   RunFile.new(file)
        # end
        #
        # @observer.watch(@test_framework.test_helper) do
        #   RunAll.new
        # end
      end

      # ==== Returns
      #  TrueClass: Find a gemspec in the user current dir
      #  FalseClass: Don't Find a gemspec in the user current dir
      #
      def self.run?
        Dir["*.gemspec"].present?
      end
    end
  end
end