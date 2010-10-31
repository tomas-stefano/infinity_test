module InfinityTest
  class Heuristics
    attr_reader :patterns, :script

    def initialize
      @patterns = {}
      @script = InfinityTest.watchr
      @application = InfinityTest.application
    end
    
    def add(pattern, &block)
      @patterns[pattern] = block
      @script.watch(pattern, &block) # Watchr
      @patterns
    end
    
    def remove(pattern)
      if pattern == :all
        @patterns.clear
        @script.rules.clear
      else
        @patterns.delete(pattern)
        @script.rules.delete_if { |rule| rule.pattern == pattern }
      end
    end
    
    def all
      @patterns.keys
    end
    
    def run(options)
      @application.run_commands_for_file(@application.files_to_run!(options))
    end
    
  end
end