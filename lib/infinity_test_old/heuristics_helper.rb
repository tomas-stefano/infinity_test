module InfinityTest
  module HeuristicsHelper

    def heuristics(&block)
      InfinityTest.configuration.heuristics(&block)
    end

  end
end
