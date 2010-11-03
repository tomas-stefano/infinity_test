module InfinityTest
  module ApplicationLibrary
    class RubyGems
      include HeuristicsHelper
      attr_accessor :lib_pattern, :test_pattern, :application, :test_helper_pattern
      
      def initialize
        @application  = InfinityTest.application
        @lib_pattern  = "^lib/*/(.*)\.rb"
        if @application.using_test_unit?
          @test_pattern = "^test/*/(.*)_test.rb"
          @test_helper_pattern = "^test/*/test_helper.rb"
        else
          @test_pattern = "^spec/*/(.*)_spec.rb"
          @test_helper_pattern = "^spec/*/spec_helper.rb"
        end        
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
          
          add(rubygems.test_helper_pattern) do |file|
            run :all => :tests
          end
          
        end
      end

    end
  end
end