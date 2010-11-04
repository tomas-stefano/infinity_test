module InfinityTest
  module TestLibrary
    class Cucumber < TestFramework
      binary :cucumber
      parse_results :passed => /(\d+) passed/, :failed => /(\d+) failed/
      
    end
  end
end