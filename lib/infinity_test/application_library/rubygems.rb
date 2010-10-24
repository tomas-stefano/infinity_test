module InfinityTest
  module ApplicationLibrary
    class RubyGems
      include HeuristicsHelper
      attr_accessor :lib_pattern, :test_pattern, :application
      
      def initialize
        @application = InfinityTest.application
        @lib_pattern = "^lib/*/(.*)\.rb"
        @test_pattern = @application.using_test_unit? ? "^test/*/(.*)_test.rb" : "^spec/*/(.*)_spec.rb"
        add_heuristics!
      end
      
      # Add Heuristics to send to Watchr Methods
      # This methods aren't tested!
      #
      def add_heuristics!
        heuristics do
          
          add(@lib_pattern) do |file|
            run file
          end
          
          add(@test_directory) do |file|
            run :test => file
          end
                    
        end
      end

      #   
      # script.watch(library_directory_pattern) do |file|
      #   @application.run_changed_lib_file(file)
      # end
      #   add(library_directory) do |file|
      #     run file
      #   end
      #   
      #   add(test_directory) do |file|
      #     run_test_file file
      #   end
      #   
      # end
      
      #
      # heuristics do
      #
      #  add application.library_directory_pattern do |changed_file|
      #     run :file => changed_file
      #  end
      #
      # end
      #
      # application.heuristics # => <Heuristics patterns={}>
      
      # def heuristics(&block)
      #   application.heuristics.instance_eval(&block)
      # end
      
      #
      #  heuristics_for(application.library_directory_pattern) do |changed_file|
      #    application.run_changed_lib(changed_file)
      #  end
      #
      #  heuristics_for 
      #
      #   def initialize
      #     heuristics do
      #       add("^lib/*/(.*)\.rb") do |file|
      #         run :file => file
      #       end
      #     end
      #   end
      # 
      #   def watch_lib_folder
      #     heuristics.pattern("^lib/*/(.*)\.rb") do |changed_file|
      #       
      #     end
      #   end
      #
    end
  end
end