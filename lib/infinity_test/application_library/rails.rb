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
            run(:all => :files)
          end
          
          add(rails.routes_pattern) do |file|
            run(:all => :files)
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

# module InfinityTest
#   class Rails
#     attr_accessor :test_framework,:test_mappings
# 
#     def initialize(options={})
#       @test_framework= :rspec
#       @test_mappings=[]
#       init_add_mappings
#     end
#     
#     #Retrun files for test
#     #
#     def test_files_for(filename)
#       result = @test_mappings.find { |file_re, ignored| filename =~ file_re }
#       result = result.nil? ? [] : [result.last.call(filename, $~)].flatten
#     end
# 
#     #Return the rails watch_path
#     def app_watch_path
#       ["^app/*/(.*)\.rb", "^app/views/(.*)", "^config/((boot|environment(s/test)?).rb|database.yml)"]
#     end
# 
#     #init test_mappings
#     #
#     def init_add_mappings
#       case @test_framework
#       when InfinityTest::TestLibrary::Rspec
#         rspec_mapping
#       when InfinityTest::TestLibrary::TestUnit
#         test_unit_mapping
#       end
#       nil
#     end
# 
# 
#     #Return the test_framework files match reg
#     #
#     def files_matching(reg)
#       @test_framework.all_files.select { |k| k =~ reg }
#     end
# 
#    #Add test_mappings,come from Autotest
#    #
#     def add_mapping(regexp, prepend = false, &proc)
#       if prepend then
#         @test_mappings.unshift [regexp, proc]
#       else
#         @test_mappings.push [regexp, proc]
#       end
#       nil
#     end
# 
# 
# 
#     private
#     #rspec and test_unit mappings  from Autotest
#     def rspec_mapping
#       add_mapping(%r%^(test|spec)/fixtures/(.*).yml$%) { |_, m|
#         ["spec/models/#{m[2].singularize}_spec.rb"] + files_matching(%r%^spec\/views\/#{m[2]}/.*_spec\.rb$%)
#       }
#       add_mapping(%r%^spec/(models|controllers|routing|views|helpers|mailers|requests|lib)/.*rb$%) { |filename, _|
#         filename
#       }
#       add_mapping(%r%^app/models/(.*)\.rb$%) { |_, m|
#         ["spec/models/#{m[1]}_spec.rb"]
#       }
#       add_mapping(%r%^app/views/(.*)$%) { |_, m|
#         files_matching %r%^spec/views/#{m[1]}_spec.rb$%
#       }
#       add_mapping(%r%^app/controllers/(.*)\.rb$%) { |_, m|
#         if m[1] == "application_controller"
#           files_matching %r%^spec/controllers/.*_spec\.rb$%
#         else
#           ["spec/controllers/#{m[1]}_spec.rb"]
#         end
#       }
#       add_mapping(%r%^app/helpers/(.*)_helper\.rb$%) { |_, m|
#         if m[1] == "application" then
#           files_matching(%r%^spec/(views|helpers)/.*_spec\.rb$%)
#         else
#           ["spec/helpers/#{m[1]}_helper_spec.rb"] + files_matching(%r%^spec\/views\/#{m[1]}/.*_spec\.rb$%)
#         end
#       }
#       add_mapping(%r%^config/routes\.rb$%) {
#         files_matching %r%^spec/(controllers|routing|views|helpers)/.*_spec\.rb$%
#       }
#       add_mapping(%r%^config/database\.yml$%) { |_, m|
#         files_matching %r%^spec/models/.*_spec\.rb$%
#       }
#       add_mapping(%r%^(spec/(spec_helper|support/.*)|config/(boot|environment(s/test)?))\.rb$%) {
#         files_matching %r%^spec/(models|controllers|routing|views|helpers)/.*_spec\.rb$%
#       }
#       add_mapping(%r%^lib/(.*)\.rb$%) { |_, m|
#         ["spec/lib/#{m[1]}_spec.rb"]
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
#       add_mapping %r%^app/helpers/application_helper.rb% do
#         files_matching %r%^test/(views|functional)/.*_test\.rb$%
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