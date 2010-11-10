module InfinityTest
  module TestLibrary
    class Cucumber < TestFramework
      include HeuristicsHelper
      binary :cucumber
      parse_results :passed => /(\d+) passed/, :failed => /(\d+) failed/

      def initialize
        add_heuristics!
      end

      def add_heuristics!
        heuristics do
          add("^features/*/*feature") do
            run :all => :tests, :in_dir => :steps_definitions
          end
        end
      end

    end
  end
end
