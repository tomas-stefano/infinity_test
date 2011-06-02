module InfinityTest
  class Runner
    attr_reader :options, :application

    def initialize(argv)
      @options = Options.new(argv)
      @application = InfinityTest.application
    end

    def run!
      @application.load_configuration_file_or_read_the_options!(@options)
      if @options[:show_heuristics?]
        list_heuristics!
      else
        @application.run_global_commands!
        start_continuous_testing!
      end
    end

    def list_heuristics!
      @application.heuristics.patterns.keys.each do |pattern|
        puts %{- "#{pattern}"}
      end
      exit
    end

    # Start Continuous Server using Watchr
    #
    def start_continuous_testing!
      InfinityTest::ContinuousTesting.new.start!
    end

  end
end
