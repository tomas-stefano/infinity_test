module InfinityTest
  module ApplicationLibrary
    class Rails
      include HeuristicsHelper
      attr_accessor :lib_pattern, :test_pattern, :configuration_pattern, :app_pattern, :routes_pattern
      
      def initialize
        @application  = InfinityTest.application
        @configuration_pattern = "^config/application.rb"
        @routes_pattern = "^config/routes\.rb"
        @lib_pattern  = "^lib/*/(.*)\.rb"
        @test_pattern = @application.using_test_unit? ? "^test/*/(.*)_test.rb" : "^spec/*/(.*)_spec.rb"
        @app_pattern = "^app/*/(.*)\.rb"
      end

      def add_heuristics!
        rails = self
        heuristics do
          
          add(rails.configuration_pattern) do |file|
            run(:all)
          end
          
          add(rails.routes_pattern) do |file|
            run(:all)
          end
          
          add(rails.lib_pattern) do |file|
            run :test_for => file
          end
          
          add(rails.test_pattern) do |file|
            run file
          end
          
          add(rails.app_pattern) do |file|
            run :test_for => file
          end
          
        end
      end
      
    end
  end
end