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
#     
#       add_mapping(%r%^config/routes\.rb$%) {
#         files_matching %r%^spec/(controllers|routing|views|helpers)/.*_spec\.rb$%
#       }
#       add_mapping(%r%^(spec/(spec_helper|support/.*)|config/(boot|environment(s/test)?))\.rb$%) {
#         files_matching %r%^spec/(models|controllers|routing|views|helpers)/.*_spec\.rb$%
#       }
#       add_mapping(%r%^app/mailers/(.*)\.rb$%) { |_, m|
#         ["spec/mailers/#{m[1]}_spec.rb"]
#       }
# 
#     end
# 
#     def test_unit_mapping
#       add_mapping %r%^test/fixtures/(.*)s.yml% do |_, m|
#         ["test/unit/#{m[1]}_test.rb",
#         "test/controllers/#{m[1]}_controller_test.rb",
#         "test/views/#{m[1]}_view_test.rb",
#         "test/functional/#{m[1]}_controller_test.rb"]
#       end
# 
#       add_mapping %r%^test/(unit|integration|controllers|views|functional)/.*rb$% do |filename, _|
#         filename
#       end
# 
#       add_mapping %r%^app/models/(.*)\.rb$% do |_, m|
#         "test/unit/#{m[1]}_test.rb"
#       end
# 
#       add_mapping %r%^app/helpers/(.*)_helper.rb% do |_, m|
#         if m[1] == "application" then
#           files_matching %r%^test/(views|functional)/.*_test\.rb$%
#         else
#           ["test/views/#{m[1]}_view_test.rb",
#           "test/functional/#{m[1]}_controller_test.rb"]
#         end
#       end
# 
#       add_mapping %r%^app/views/(.*)/% do |_, m|
#         ["test/views/#{m[1]}_view_test.rb",
#         "test/functional/#{m[1]}_controller_test.rb"]
#       end
# 
#       add_mapping %r%^app/controllers/(.*)\.rb$% do |_, m|
#         if m[1] == "application_controller" then
#           files_matching %r%^test/(controllers|views|functional)/.*_test\.rb$%
#         else
#           ["test/controllers/#{m[1]}_test.rb",
#           "test/functional/#{m[1]}_test.rb"]
#         end
#       end
# 
#       add_mapping %r%^app/views/layouts/% do
#         "test/views/layouts_view_test.rb"
#       end
# 
#       add_mapping %r%^config/routes.rb$% do
#         files_matching %r%^test/(controllers|views|functional)/.*_test\.rb$%
#       end
# 
#       add_mapping %r%^test/test_helper.rb|config/((boot|environment(s/test)?).rb|database.yml)% do
#         files_matching %r%^test/(unit|controllers|views|functional)/.*_test\.rb$%
#       end
#     end
#   end
# end
# 