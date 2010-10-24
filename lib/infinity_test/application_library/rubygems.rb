module InfinityTest
  module ApplicationLibrary
    class RubyGems
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