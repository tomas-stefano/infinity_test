module InfinityTest
  module ApplicationLibrary
    class Rails
      include HeuristicsHelper
      attr_accessor :lib_pattern, 
                    :test_pattern, 
                    :configuration_pattern, 
                    :routes_pattern, 
                    :fixtures_pattern,
                    :controllers_pattern, 
                    :models_pattern,
                    :helpers_pattern,
                    :mailers_pattern,
                    :application_controller_pattern,
                    :application_helper_pattern
      
      def initialize
        @application = InfinityTest.application
        resolve_patterns!
      end

      def add_heuristics!
        rails = self
        heuristics do
          
          add(rails.application_controller_pattern) do |file|
            run :all => :tests, :in_dir => :controllers
          end
          
          add(rails.application_helper_pattern) do |file|
            run :all => :tests, :in_dir => [:helpers, :views]
          end
          
          add(rails.configuration_pattern) do |file|
            run(:all => :tests)
          end
          
          add(rails.routes_pattern) do |file|
            run(:all => :tests)
          end
          
          add(rails.controllers_pattern) do |file|
            run :test_for => file, :in_dir => :controllers
          end
          
          add(rails.models_pattern) do |file|
            run :test_for => file, :in_dir => :models
          end
          
          add(rails.helpers_pattern) do |file|
            run :test_for => file, :in_dir => :helpers
          end
          
          add(rails.mailers_pattern) do |file|
            run :test_for => file, :in_dir => :mailers
          end
          
          add(rails.lib_pattern) do |file|
            run :test_for => file, :in_dir => :lib
          end
          
          add(rails.test_pattern) do |file|
            run file
          end
          
          add(rails.fixtures_pattern) do |file|
            run :all => :tests, :in_dir => :models
          end
          
        end
      end
      
      def resolve_patterns!
        @configuration_pattern = "^config/application.rb"
        @routes_pattern = "^config/routes\.rb"
        @lib_pattern  = "^lib/*/(.*)\.rb"
        if @application.using_test_unit?
          @test_pattern = "^test/*/(.*)_test.rb"
          @fixtures_pattern = "^test/fixtures/(.*).yml"
        else
          @test_pattern = "^spec/*/(.*)_spec.rb"
          @fixtures_pattern = "^spec/fixtures/(.*).yml"
        end
        @controllers_pattern = "^app/controllers/(.*)\.rb"
        @models_pattern = "^app/models/(.*)\.rb"
        @helpers_pattern = "^app/helpers/(.*)\.rb"
        @mailers_pattern = "^app/mailers/(.*)\.rb"
        @application_controller_pattern = "^app/controllers/application_controller.rb"
        @application_helper_pattern = "^app/helpers/application_helper.rb"
      end
      
    end
  end
end