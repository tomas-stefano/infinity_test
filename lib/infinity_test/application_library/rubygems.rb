module InfinityTest
  module ApplicationLibrary
    class RubyGems
      include HeuristicsHelper
      attr_accessor :lib_pattern, :test_pattern, :application
      
      def initialize
        @application  = InfinityTest.application
        @lib_pattern  = "^lib/*/(.*)\.rb"
        @test_pattern = @application.using_test_unit? ? "^test/*/(.*)_test.rb" : "^spec/*/(.*)_spec.rb"
      end
      
      # Add Heuristics to send to Watchr Methods
      # This methods aren't tested!
      #
      def add_heuristics!
        rubygems = self
        heuristics do

          add(rubygems.lib_pattern) do |file|
            run :test_for => file
          end
          
          add(rubygems.test_pattern) do |file|
            run file
          end
          
        end
      end

    end
  end
end