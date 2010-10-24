module InfinityTest
  class Heuristics
    attr_reader :patterns

    def initialize
      @patterns = {}
    end
    
    def add(pattern, &block)
      @patterns[pattern] = block
    end
    
    # [ <Heuristics>, <Heuristics> ]
    
    # <Heuristics patterns={:pattern => &block}>
    
  end
end