module InfinityTest
  class Heuristics
    attr_reader :patterns, :script

    def initialize
      @patterns = {}
      @script = InfinityTest.watchr
    end
    
    def add(pattern, &block)
      @patterns[pattern] = block
      @script.watch(pattern, &block)
      @patterns
    end
    
    # [ <Heuristics>, <Heuristics> ]
    
    # <Heuristics patterns={:pattern => &block}>
    
  end
end