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
    
    def run(options)
      @application.run_commands_for_file(@application.files_to_run!(options))
    end
    
  end
end